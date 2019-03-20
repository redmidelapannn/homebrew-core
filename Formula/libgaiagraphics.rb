class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 5

  bottle do
    cellar :any
    sha256 "3e96c1791335ced8dd72246153adc907135fdc1b6160d343ff167a321b75f4ff" => :mojave
    sha256 "4d0df377d1dd03f00b753252a562322b12784cd61f95fa0c200bab2599dcfd6f" => :high_sierra
    sha256 "2aafee696c250cf74d60427da187ac57ff246ce0aa44e00e5cd77e3513331ce5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
