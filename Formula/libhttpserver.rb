class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.11.1.tar.gz"
  sha256 "a5c3d2fb08cce842c0e9c900340260deb20b6fc4827fa0c94306aa34e50e5239"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "49c568dadac834fed2f387368f4c049064cde933b7da594c4c47e568ba807d08" => :el_capitan
    sha256 "5675df59617c1c0a64b00166680f7f4b83fff01b7b929ad76ce2ef3886cee4b0" => :yosemite
    sha256 "ba84931a45a18f4c71ba51eb61e9fab35f14a9d19d325aa8faa15d1380a7edd3" => :mavericks
  end

  option :universal

  depends_on "libmicrohttpd"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
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
