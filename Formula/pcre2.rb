class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.22.tar.bz2"
  sha256 "b2b44619f4ac6c50ad74c2865fd56807571392496fae1c9ad7a70993d018f416"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e14bf966538f899764add21de3dd588ddac0c22447e8185d29cd04c7a249a901" => :sierra
    sha256 "ada797bb8b27b372b1d7e07ed12403accf2594eea5799811f9751e8f53d86533" => :el_capitan
    sha256 "d16e79c4695ea7defa3ff1bcb461ae065618d533b417b09f71b21bf76fc0289f" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
