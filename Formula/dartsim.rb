class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.4.0.tar.gz"
  sha256 "7a9e6e081d1cb910a7c9c996d76dd48ddca15b798c6d9a3cc7664534e5d28a84"
  revision 1

  bottle do
    rebuild 1
    sha256 "b0216fd74c9576c020f4ffb1c4e4f7b417e85623ff39e0c6b192298f3d52c015" => :high_sierra
    sha256 "4a5381bc05e89386a648c6252f44acbd025b3badbf5240145dfaa4c1eb10e55e" => :sierra
    sha256 "c161adda710244de19e1d28130f94fcd2d7bf483c9115ac246b1fb5deb2992b4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "freeglut"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-lassimp", "-lboost_system", "-std=c++11", "-o", "test"
    system "./test"
  end
end
