class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dist/thrift/0.12.0/thrift-0.12.0.tar.gz"
  sha256 "c336099532b765a6815173f62df0ed897528a9d551837d627c1f87fadad90428"

  bottle do
    cellar :any
    sha256 "3234e86b4374879b3ec29b51218335e2d88e5b710dd6374ee507e19303818758" => :mojave
    sha256 "4e7f89888dbe2369b3ea9c5517349be25f85f8af62514bbc7589817d443a4acd" => :high_sierra
    sha256 "d7e7833240e9133be12c74aaa65674200d61b803e0a940c579e955d5bc9660fc" => :sierra
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
  depends_on "openssl"

  def install
    system "./bootstrap.sh" unless build.stable?

    args = %W[
      --disable-debug
      --disable-tests
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-erlang
      --without-haskell
      --without-perl
      --without-php
      --without-php_extension
      --without-ruby
      --without-java
      --without-python
    ]

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

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
