class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now (using - instead of _ in the version field).
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20170228.tar.gz"
  version "3.6.1-20170228"
  sha256 "8de2f2ae70f71455288ec85c96a2579391300c7462f69a4a6398e9ec51779c11"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    rebuild 1
    sha256 "0152a8b18af432488288efd1f10db8ff0332e748b2bb93cdd2b388ef71b8afad" => :sierra
    sha256 "e4696c4b47faf17e048ebd909c1eda913a04c37cc55a761bea260f8e4dff7d35" => :el_capitan
    sha256 "c0e8759fc0a9684600800436b2060022cf5affc3ab7a3003056627fa9e9a63cc" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    args = std_cmake_args
    args << "-DDCMTK_WITH_OPENSSL=YES"
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
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
