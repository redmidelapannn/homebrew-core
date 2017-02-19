class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "https://ufraw.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"
  revision 1

  bottle do
    rebuild 1
    sha256 "6fbb0091ec79dcc24a1d4985d2252ca5cf28eb1e9ee811ea06ca6d86706e05dd" => :sierra
    sha256 "de629e0c09b1cf6dd90418d983e806bae248561e27ac5d235278b4f322e3b7b0" => :el_capitan
    sha256 "1b5189da26b83e6afaa8bead317077b3ca854f630e35d319f99d8f1a58f45f43" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "dcraw"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "exiv2" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share/"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end
