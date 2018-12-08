class Teem < Formula
  desc "Libraries for scientific raster data"
  homepage "https://teem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz"
  sha256 "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def"
  head "https://svn.code.sf.net/p/teem/code/teem/trunk"

  bottle do
    rebuild 1
    sha256 "092df1be1ed21b727da80fa620a5ad951bec905fc4e1d68516e72d4b58f8aa73" => :mojave
    sha256 "c840a11e75806e28decc0398af648c825db2060c45e934e0f6d49ae051628948" => :high_sierra
    sha256 "9d93464c3b8306170a994007ce1cc45bf6767459209b3dd8114691642e99d6c0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Installs CMake archive files directly into lib, which we discourage.
    # Workaround by adding version to libdir & then symlink into expected structure.
    system "cmake", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS:BOOL=ON",
                    "-DTeem_USE_LIB_INSTALL_SUBDIR:BOOL=ON"
    system "make", "install"

    lib.install_symlink Dir.glob(lib/"Teem-#{version}/*.dylib")
    (lib/"cmake/teem").install_symlink Dir.glob(lib/"Teem-#{version}/*.cmake")
  end

  test do
    system "#{bin}/nrrdSanity"
  end
end
