class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 6

  bottle do
    cellar :any
    sha256 "9baf9a851df619789e8a224c25561d5cd791cfc997a2456ea9f19f187a529104" => :mojave
    sha256 "00f33471e53c88d2ac9f754985c0bbf765316c28d2a4ce216763b671e20247ab" => :high_sierra
    sha256 "90de426bc568695d4d42b283687e755d1a96b613474e8e917f16e1ae19754bd2" => :sierra
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
