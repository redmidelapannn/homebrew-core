class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.1/mozjpeg-3.1-release-source.tar.gz"
  sha256 "deedd88342c5da219f0047d9a290cd58eebe1b7a513564fcd8ebc49670077a1f"

  bottle do
    cellar :any
    revision 2
    sha256 "3a01cac37b6ff9300f362f998c511761cb747c28ccadb30a3bf6fa09ec7b9097" => :el_capitan
    sha256 "5334b5a58c06e831ddf4312f3620e5edf04b661f9b29ae6b296f3f49c223a69e" => :yosemite
    sha256 "5d914a3fc3f0e44d51e3097f5b8c1d4e07ffd368870816d7cebd3c13198088a8" => :mavericks
  end

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-optimize",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
