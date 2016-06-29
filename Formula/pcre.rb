class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre/8.39/pcre-8.39.tar.bz2"
  sha256 "b858099f82483031ee02092711689e7245586ada49e534a06e678b8ea9549e8b"

  bottle do
    cellar :any
    revision 1
    sha256 "bb3616051401b66f10883a902940ea2a0f9475d71814f3f4c196287c47c59562" => :el_capitan
    sha256 "7f1fd4a3135d6c209dd06a726db7b31ff8fbe6f63351fc575fd703fd1d3762cd" => :yosemite
    sha256 "c86d30e3935b942bc8c3dccf4b77b47ca48d908a8bd0cc2e343a72e7acd77812" => :mavericks
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
