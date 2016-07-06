class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v3.3.tar.gz"
  sha256 "a57359ae31e2a5ef4167eadb7c11a3339bd9cb4a5f6241c0fb22db0aebaf4436"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha256 "c4c83fbe32d20931054d766950af0f212f9ff7be822284049592838cae3f582a" => :el_capitan
    sha256 "7423be6035f659f74f98483d3281d9bd946b02196aad5db1d934216720baeddc" => :yosemite
    sha256 "90b4a634d9e24a44182ec44fe99cf730ef0ed08459cdd33a9c354e2b6466d54a" => :mavericks
  end

  option "without-boost", "Compile without thread safe logging or multithreaded computation if boost isn't installed"

  depends_on "cmake" => :build
  depends_on "boost" => [:recommended, :build]

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<-EOS.undent
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      v -0.5 0 0.5    # Front left.
      v 0.5 0 0.5   # Front right.
      v 0.5 0 -0.5    # Back right
      v -0.5 0 -0.5   # Back left.
      v 0 1 0           # Top point (top of pyramid).

      # List of faces:
      f 4 3 2 1       # Square base (note: normals are placed anti-clockwise).
      f 1 2 5         # Triangle on front.
      f 3 4 5         # Triangle on back.
      f 4 1 5         # Triangle on left side.
      f 2 3 5
    EOS
    system "assimp", "export", testpath/"test.obj", testpath/"test.ply"
  end
end
