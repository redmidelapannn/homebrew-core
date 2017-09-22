class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.13.0.tar.gz"
  sha256 "78ddbd9e173eed1cbbb2f25a22c1fa58c987958c09b96556d33167781df1dd33"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "f76679a624ea5aa854ec42afe8499367e84097ec66603a3fa2546020e58edb63" => :sierra
    sha256 "0ad1fd14bce23878d1584a020db1e647b9ebbcb0459fb0f5a116dfff349344b9" => :el_capitan
  end

  depends_on "libmicrohttpd"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
    system ENV.cxx, pkgshare/"examples/hello_world.cpp",
      "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"
    pid = fork { exec "./hello_world" }
    sleep 1 # grace time for server start
    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:8080/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
