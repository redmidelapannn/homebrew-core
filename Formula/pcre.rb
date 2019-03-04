class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.43.tar.bz2"
  sha256 "91e762520003013834ac1adb4a938d53b22a216341c061b0cf05603b290faf6b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2ebb137b40145a3b58493912d4cbff32b63bb12c29340c303c4fc5e22f4aee9" => :mojave
    sha256 "6330e2c5d5852b1e3eea70f162ff19902134b0e89bee4b4006477e1127a64492" => :high_sierra
    sha256 "07007156966de80de5aaee766147fa5c92919902882a86eac5d574623ffdec1a" => :sierra
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-pcre8
      --enable-pcre16
      --enable-pcre32
      --enable-unicode-properties
      --enable-pcregrep-libz
      --enable-pcregrep-libbz2
    ]
    args << "--enable-jit" if MacOS.version >= :sierra

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
