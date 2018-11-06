class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.14.0.tar.gz"
  sha256 "6b8e2ef3d6806ca8443293e683121b2bfce70bedd7129303c43bc4dee356b171"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "24f60c5ae04d52c13de56c095b65d4a5ec2645c7de25663b0f2dba5c4e7e315a" => :mojave
    sha256 "118277615a80f3056530dac07d3bb0c4dcb8ebaa318d317b7795f97e21337ce8" => :high_sierra
    sha256 "0665789e905350a6088688caea50c5770c5fd821d22bfa4a761dac2993e0b28a" => :sierra
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
