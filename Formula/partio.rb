class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.7.3.tar.gz"
  sha256 "370a707b1feeb68e3a14e7318455c2eaa41f2096bd62877f638d0b4c2bda54aa"

  bottle do
    cellar :any
    sha256 "eadbaa8de1f905bd46cff2066792779cb8046192eb730e766325367c716e32e7" => :mojave
    sha256 "8148ca9a552ab1f3d37f11fa2614668f57658670100d81dfdbc522e6af18afe4" => :high_sierra
    sha256 "e21cd5cf344f04030d99161dea6461ae017a2282fa5e7acd96cfec90945d94bd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "swig" => :build

  # This fix is upstream and can be removed in the next released version.
  patch do
    url "https://github.com/wdas/partio/commit/e83243b.diff?full_index=1"
    sha256 "452c88b81a2a6bff88bbdbdebeaebb2e3c9c1ea8f140be5e7a941270774c14c3"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
  end
end
