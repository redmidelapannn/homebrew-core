class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre/8.39/pcre-8.39.tar.bz2"
  sha256 "b858099f82483031ee02092711689e7245586ada49e534a06e678b8ea9549e8b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0b91ca985f8b85573df6672415059f72e9ef00d7d3d6d76181f8738426c68e49" => :sierra
    sha256 "aec7f78924629ef0c34d56a8832f7125fb05b07696254ff14cf2be986678ae19" => :el_capitan
    sha256 "26a2119cd0bd75a2e7e72d67cf988637e91da97fa0e311bcea6f915fc1d23ba8" => :yosemite
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

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
