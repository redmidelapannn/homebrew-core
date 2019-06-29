class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk364/dcmtk-3.6.4.tar.gz"
  sha256 "a93ff354fae091689a0740a1000cde7d4378fdf733aef9287a70d7091efa42c0"
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    rebuild 1
    sha256 "b41d7aee3a306a26f5c7da47dba7e93dcf1c04575078cae89c412a0e07e77f11" => :mojave
    sha256 "e72584fd0f38e9696b07ea058b8258f49035a6846789ea56ddb0c891be50a031" => :high_sierra
    sha256 "039bf60f7e2b80394268cdc495f6eb0af9ed9d30a438fd17d3b70ee60c3b7cf4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
