class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.6.tar.gz"
  sha256 "e9163650955ab8e4b9532e7aa43b841bac45701f7b0f9b793a98c8ca3ef14072"

  bottle do
    cellar :any
    sha256 "2a52dc7580a50c7c4f31ec4a11d907ba142e1b91b49ce67a9f42beafce7ca16a" => :mojave
    sha256 "50b33ec49fb9cfbe69a52c144b9f964c7f794f653b7167ae707795fd28ff2682" => :high_sierra
    sha256 "52e765b9737ea7f33f33cddbed62bf38db3e0bc009f720a7d181ad813f4fd83d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

  # Upstream commit, remove in next release
  # https://sourceforge.net/p/podofo/tickets/24/
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/ae70aa7e/graphics/podofo/files/podofo-cmake-3.12.patch"
    sha256 "877501b55bd5502dcaf048d3811b81fada2bd005e2247a2412a88b3035edd51f"
  end

  def install
    freetype = "#{Formula["freetype"].opt_include}/freetype2"
    args = std_cmake_args + %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{freetype}
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{freetype}/config/
      -DPODOFO_BUILD_SHARED:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

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
