class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.13.0/thrift-0.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.13.0/thrift-0.13.0.tar.gz"
  sha256 "7ad348b88033af46ce49148097afe354d513c1fca7c607b59c33ebb6064b5179"

  bottle do
    cellar :any
    rebuild 1
    sha256 "673463fd98cf2ab655b2bbc4f9d1a8a66f717aa79355ae402f11e51238d7f94e" => :catalina
    sha256 "71504087cd35b8fabca1fce2596c852974252b299ca1a62ace9bd31d49c1bf3d" => :mojave
    sha256 "ae0f8510870c2ad77b9afb2c4ebb23bf68c6c02e300aa52357a127b0f652847d" => :high_sierra
  end

  head do
    url "https://github.com/apache/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "bison" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-erlang
      --without-haskell
      --without-java
      --without-perl
      --without-php
      --without-php_extension
      --without-python
      --without-ruby
      --without-swift
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = buildpath

    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/thrift", "--version"
  end
end
