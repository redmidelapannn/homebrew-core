class Xpdf < Formula
  desc "PDF tools and viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://www.xpdfreader.com/dl/xpdf-4.00.tar.gz"
  sha256 "ff3d92c42166e35b1ba6aec9b5f0adffb5fc05a3eb95dc49505b6e344e4216d6"

  bottle do
    cellar :any
    sha256 "9866c3107e953217a15db98fd4924f0b029e83c87b99f11ff18473aa1e035fac" => :sierra
    sha256 "bb30b06df6ac9d3ecbd1ae38f09073b61c43eae76e540e9073983ec86b7dad65" => :el_capitan
    sha256 "667a6cf9d9c896f7ed357cfd57ac0bdf3d43420312dd57ed81dea72980391ca6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qt" => :optional

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
