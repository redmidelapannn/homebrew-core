class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.17.5.tar.gz"
  sha256 "778fa0aec199bf8737b2d540c2563a694c18957329f9885e372f7aaafb838351"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "63a51a204d547355a6152c287810f284cb6b9e8a5054e91cd170192fbc48ce64" => :catalina
    sha256 "7bd5dd782cba6455dacf5c2edfca8d125e5a3b5f3a470d4e1ee01905492de33f" => :mojave
    sha256 "3b4b112bc09dab418dca1df3e1d5ca40356992b1ec5b32a93bb72667c594be6a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/hello_world.cpp", testpath
    inreplace "hello_world.cpp", "create_webserver(8080)",
                                 "create_webserver(#{port})"

    system ENV.cxx, "hello_world.cpp",
      "-std=c++11", "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    pid = fork { exec "./hello_world" }

    sleep 1 # grace time for server start

    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
