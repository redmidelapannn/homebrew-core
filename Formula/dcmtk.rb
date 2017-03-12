class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now (using - instead of _ in the version field).
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20170228.tar.gz"
  mirror "http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.6.1_20170228.tar.gz"
  version "3.6.1-20170228"
  sha256 "8de2f2ae70f71455288ec85c96a2579391300c7462f69a4a6398e9ec51779c11"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    rebuild 1
    sha256 "53ce89ae122f4ad495b9fa276a75e794c063fabe337802700a938009df5ce18b" => :sierra
    sha256 "9f6187b019e95c0cb6786e24237b32f28ebef13713853409753e03a327745f67" => :el_capitan
    sha256 "0cebab6715209f1cb3f5e55adb3b1ffa902d48e72d59f6d6c52946165a2a46a0" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."
  option "with-dicomdict", "Build with baked-in DICOM data dictionary."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl" => :recommended
  depends_on "homebrew/dupes/libiconv" => :optional

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
