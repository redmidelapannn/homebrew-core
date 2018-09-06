class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk363/dcmtk-3.6.3.tar.gz"
  sha256 "63c373929f610653f10cbb8218ec643804eec6f842d3889d2b46a227da1ed530"
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    rebuild 1
    sha256 "fe1ab49f12150416b937c5fc0bcbb2fe60d31749ef3dd657854a20a326989e34" => :mojave
    sha256 "bb217386b475560674c8c67aba4c725b3c9767f4092516a4ee6e6a50c0a81d93" => :high_sierra
    sha256 "7f68abfcb06e5aa903a04c71738a731b329ea18319eee9b50956edf4d9d627f9" => :sierra
    sha256 "9e70fecdbeb38d1398f8f44515c5439e173b24daa7ba44a2e3482f63c89fcc88" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

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
