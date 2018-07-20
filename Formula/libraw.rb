class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.0.tar.gz"
  sha256 "e83f51e83b19f9ba6b8bd144475fc12edf2d7b3b930d8d280bdebd8a8f3ed259"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a10c5edff3a784c96f3098dba797750bf5b17fcb51a03dc663bf9caa8573a7eb" => :high_sierra
    sha256 "86a75c595346450162f16b6a4b58432316fa9012645ab71828e9bceb9c97301e" => :sierra
    sha256 "c99c0bec4d261aaece4b8ddc1e657654c07bb9e4238eb5ec5565bbad52baa6cb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
