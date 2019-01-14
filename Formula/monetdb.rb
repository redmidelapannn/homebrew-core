class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Aug2018-SP2/MonetDB-11.31.13.tar.xz"
  sha256 "f9fbf63ed7e6c306868b289c3fda8c3a8b6d3fc6bef589418940b2a21fd7c283"
  revision 1

  bottle do
    sha256 "1c3126ed23891d21d64e284852d106c6a8d767f54615b3bdbdd4ee3f26b0aef1" => :mojave
    sha256 "432eaed82640bce00d9df54531f5bfa78c45331752d3bc8543b48f24aaeffe09" => :high_sierra
    sha256 "9a75026f124dcb2f7e5fa1324fb2a92c5091c5ef3021704411c71478f67a3f2d" => :sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make", "install"
  end
end
