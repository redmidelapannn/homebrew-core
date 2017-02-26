class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre/8.39/pcre-8.39.tar.bz2"
  sha256 "b858099f82483031ee02092711689e7245586ada49e534a06e678b8ea9549e8b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "43327bdc4127db03cb4f0cb51cf8cac9a23a216ea62962a5ebabd60857d06c5f" => :sierra
    sha256 "4055f61f6ffc22c191a5caf61826781c3468184b2142f1dfae42da5059a4cea3" => :el_capitan
    sha256 "9b342a20222a11e8e1861d6277bf1a4a5ce597fdbd6c0e12d49797458a715be3" => :yosemite
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
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
