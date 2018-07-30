class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk363/dcmtk-3.6.3.tar.gz"
  sha256 "63c373929f610653f10cbb8218ec643804eec6f842d3889d2b46a227da1ed530"
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    rebuild 1
    sha256 "3183aaf0e6e6696faec2b64ee7117c74688872741ac078a9ba581857d508bb1f" => :high_sierra
    sha256 "19fe22583c1a0f8de37858f5526a9f9e9a428688af19772d3b46cd69433a2b32" => :sierra
    sha256 "f77d37855b2ce7c06145c4e1c3276f2808df64d81900fc08babf6c366d33bf47" => :el_capitan
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."
  option "with-dicomdict", "Build with baked-in DICOM data dictionary."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl" => :recommended
  depends_on "libiconv" => :optional

  def install
    args = std_cmake_args
    args << "-DDCMTK_WITH_OPENSSL=NO" if build.without? "openssl"
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_ENABLE_BUILTIN_DICTIONARY=YES -DDCMTK_ENABLE_EXTERNAL_DICTIONARY=NO" if build.with? "dicomdict"
    args << "-DDCMTK_WITH_ICONV=YES -DLIBICONV_DIR=#{Formula["libiconv"].opt_prefix}" if build.with? "libiconv"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make", "DOXYGEN" if build.with? "docs"
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
