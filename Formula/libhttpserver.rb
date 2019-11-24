class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.17.5.tar.gz"
  sha256 "778fa0aec199bf8737b2d540c2563a694c18957329f9885e372f7aaafb838351"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "63ea11953393b96e06b0f647837751cfcd4e3b3b586005acbfac29833efe244c" => :catalina
    sha256 "850eb8a365ca996c1c8fa80570eff17a94a1d6aa8bdb2ff18f61c453e3b43a64" => :mojave
    sha256 "69c42f8a509b4526d08998c353bc084b0e5b15c85ccbc6621f10fe71479fa7a5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

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
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

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
