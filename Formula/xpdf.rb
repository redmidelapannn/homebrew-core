class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.00.tar.gz"
  mirror "https://fossies.org/linux/misc/xpdf-4.00.tar.gz"
  sha256 "ff3d92c42166e35b1ba6aec9b5f0adffb5fc05a3eb95dc49505b6e344e4216d6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef991c1447e85b40683d335f774e7958dbb1aed8d5225e57256dafb1364a2a3d" => :high_sierra
    sha256 "8f387ac44538eaee9cd47101685d952808f0959c8afa7567f3f5efc24c4317d0" => :sierra
    sha256 "2a6bca378170ba1463a0d0ac2d71c38ab5cba5b30e3f4fa4a06d938071060bfe" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    # Reported 6 Feb 2018 to xpdf AT xpdfreader DOT com
    inreplace ["xpdf/CMakeLists.txt", "xpdf-qt/CMakeLists.txt"], " man/",
                                                                 " share/man/"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
