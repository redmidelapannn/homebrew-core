class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://xpdfreader-dl.s3.amazonaws.com/xpdf-4.02.tar.gz"
  sha256 "52d51dc943b9614b8da66e8662b3031a3c82dc25bfc792eac6b438aa36d549a4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "810736a738f63ce159b135d7abe5bb747acd29c54fd799a03aa089e6a259cdb2" => :catalina
    sha256 "e388b9c857cf2c8f2ec22401df9cd6035684f1592399851a45c35c0ca14fa81d" => :mojave
    sha256 "98fc24151b5135a50177a5c29c4c308537d9b49fec8a6eb512c4586c68ecb4a4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "qt"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
