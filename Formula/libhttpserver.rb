class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  revision 1
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b2dda0168650e9e3c6a360d972408a05201e1194597804aa095b9f7328365fc" => :sierra
    sha256 "861ca149358531023f58e484161d2802a4218e7d3392e0f2cdb299444fccbd3c" => :el_capitan
    sha256 "a39d2894e620e28f8dbac4af2911236693f7bf9c30029b147503e7b2e771156d" => :yosemite
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
      "-o", "hello_world", "-lhttpserver", "-lcurl"
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
