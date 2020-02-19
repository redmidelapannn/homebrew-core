class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.13.0/thrift-0.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.13.0/thrift-0.13.0.tar.gz"
  sha256 "7ad348b88033af46ce49148097afe354d513c1fca7c607b59c33ebb6064b5179"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8aff2d152a7d4a469c700ae018bc60438c58b416bd10b16b6ab06e53e0c5b745" => :catalina
    sha256 "4038fa595782c588c9e5fd0b8842eb9edc3b4b1e399281f36d9fd67f5b4f28e8" => :mojave
    sha256 "d2842ec3f92d376bf4d67c59df71e5ceb6aeae0175015e8364c5412d4807bc3e" => :high_sierra
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
