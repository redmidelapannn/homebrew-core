class Teem < Formula
  desc "Libraries for scientific raster data"
  homepage "https://teem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz"
  sha256 "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def"
  head "http://svn.code.sf.net/p/teem/code/teem/trunk"

  bottle do
    rebuild 1
    sha256 "7e7a50d62ab7c44d10d6449d02427f1f067e79be14934c698d94fb95fcea0122" => :mojave
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
