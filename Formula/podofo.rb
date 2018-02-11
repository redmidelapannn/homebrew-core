class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.5.tar.gz"
  sha256 "854981cb897ebc14bac854ea0f25305372261a48a205363fe1c61659ba7b5304"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "2c6293b67b599160040a0407e60ebffae6b041104c71f97848b70d14d02632e0" => :high_sierra
    sha256 "740fac272821062426a92c55a40374ceff9faebceffa663161df5a8e6d71f078" => :sierra
    sha256 "834cedc1dbd59aff0463e80c586c633d4fc88ac03b3c3bccf5c529fbe006e757" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "libidn" => :optional

  def install
    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_LIBIDN=ON" if build.without? "libidn"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON"

    # Build shared to simplify linking for other programs.
    args << "-DPODOFO_BUILD_SHARED:BOOL=ON"

    args << "-DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2"
    args << "-DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
