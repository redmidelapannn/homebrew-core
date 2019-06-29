class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v4.1.0.tar.gz"
  sha256 "3520b1e9793b93a2ca3b797199e16f40d61762617e072f2d525fad70f9678a71"
  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2dbcfa1b8ea62c573f2448ef7235248be74e2519244777fef30d8ba52691142d" => :mojave
    sha256 "6961c089ed7dc53291288583f526894025ae5b215c88e17728c3e907a66c7dad" => :high_sierra
    sha256 "03c8d1bec2bed974dd84ee9f202528c1156abb644101375849976835a7aabe60" => :sierra
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
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
