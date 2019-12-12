class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v5.0.0.tar.gz"
  sha256 "b0110a91650d6bb4000e3d5c2185bf77b0ff0a2e7a284bc2c4af81b33988b63c"
  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "99c7978f4436a95d1a28882b0ac1cb0c35665a7712ea6d51c18e09f5619ce0c1" => :catalina
    sha256 "b1f750083e55b4bd0733270eeab9394a91a3a6f2ddae6bf1ba26cbc0b76d8c79" => :mojave
    sha256 "66873b9eb562001ee51d37cbc649201781be45046d1336d859e4ad7a39789c23" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Fix "unzip.c:150:11: error: unknown type name 'z_crc_t'"
  # Upstream PR from 12 Dec 2017 "unzip: fix build with older zlib"
  if MacOS.version <= :el_capitan
    patch do
      url "https://github.com/assimp/assimp/pull/1634.patch?full_index=1"
      sha256 "79b93f785ee141dc2f56d557b2b8ee290eed0afc7dd373ad84715c6c9aa23460"
    end
  end

  # Fix CMake error "The imported target "assimp::assimp" references the file
  # "/usr/local/lib/libassimp.dylib.5""
  # Upstream PR from 11 Nov 2019 "Fix shared lib name on macOS"
  patch do
    url "https://github.com/assimp/assimp/pull/2765.patch?full_index=1"
    sha256 "4c8102fea4af720f65d420aa883d60e6ed0f9eb8309938793e82de69d11a23dc"
  end

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~EOS
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
