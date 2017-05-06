class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
  sha256 "e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b5d583b745469535ad30b68e4e4ec9b78dfc88e5de8ae784fea6e249ed93a1e8" => :sierra
    sha256 "ebe2477f914f0cc163c3e30b32a5d3e5f5003c87475a7cfaacdec10cd8140508" => :el_capitan
    sha256 "c9cc039972f65d7d0acc7f4062fd531167f1e68220d3b713ff7cc3563f645a1b" => :yosemite
  end

  head do
    url "https://git.xiph.org/ogg.git"

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
