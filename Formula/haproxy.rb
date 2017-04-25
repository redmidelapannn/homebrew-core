class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.4.tar.gz"
  sha256 "dc1e7621fd41a1c3ca5621975ca5ed4191469a144108f6c47d630ca8da835dbe"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b4460c0738372fb7813d7a43bc97ca5a5842d1fc266cbe3f0b73ad8ee66c5791" => :sierra
    sha256 "248432714bcf71ac1cc1619478232f94414747a83ef92ed2be03058930a4da74" => :el_capitan
    sha256 "6f6cb6c479ed0e08dc2ce3ed2239bcc499175d8a93df2937a56fd4815859cb86" => :yosemite
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua@5.3" => :optional

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    if build.with? "lua@5.3"
      args << "USE_LUA=1"
      args << "LUA_LIB_NAME=lua.5.3"
      args << "LUA_LIB=#{Formula["lua@5.3"].lib}"
      args << "LUA_INC=#{Formula["lua@5.3"].include}/lua5.3"
      args << "LUA_LD_FLAGS='-Wl -L#{Formula["lua@5.3"].lib}'"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
