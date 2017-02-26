class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
  sha256 "e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3159147499fe26b3f9b61f2da0e81ac1b904a5532bea4e9117baba77b207586f" => :sierra
    sha256 "7ed34a72e45613b7b03408b01026f8cb87ae8e7b69140864d4953d69c5bd1528" => :el_capitan
    sha256 "621d1597cf4597e1796efd064f4c4d35ea35d7f5d0c90d41610a314fbe34d7d3" => :yosemite
  end

  head do
    url "https://svn.xiph.org/trunk/ogg"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
