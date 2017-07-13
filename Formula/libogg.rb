class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
  sha256 "e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f0dbcdb70b0e7513b1e0093f0215e3794c0dff9988e6acd8749cecb81854a2df" => :sierra
    sha256 "43de483f107d8613e225d49a5960c9df0dd0455fd3b2d242b2fdd54f4c355ccd" => :el_capitan
    sha256 "62ef41f955786219e55e6ecb3c656bae8337b99a297b5a531ff9ebe737a83b0c" => :yosemite
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
