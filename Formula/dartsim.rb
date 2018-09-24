class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.6.1.tar.gz"
  sha256 "86cc3249938602754f773e0843f415c290bd2608729ab3e219de78f90bdd4d6b"
  revision 2

  bottle do
    rebuild 1
    sha256 "cc8578fb463345b364346708d51bf5795a63676f0594f2dec2b72f27fe487bbd" => :mojave
    sha256 "5985dce3c60377afc09fb438326bff6b48175fec7e1c992d1b8dfa082d487ae9" => :high_sierra
    sha256 "6b94743ebc41f18c7de83f76f35c8092d4edd055a36b77fc55b5d1539d038779" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11

    # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
    system "cmake", ".", "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework",
                         *std_cmake_args
    system "make", "install"

    # Avoid revision bumps whenever fcl's or libccd's Cellar paths change
    inreplace share/"dart/cmake/dart_dartTargets.cmake" do |s|
      s.gsub! Formula["fcl"].prefix.realpath, Formula["fcl"].opt_prefix
      s.gsub! Formula["libccd"].prefix.realpath, Formula["libccd"].opt_prefix
    end

    # Avoid revision bumps whenever urdfdom's or urdfdom_headers's Cellar paths change
    inreplace share/"dart/cmake/dart_utils-urdfTargets.cmake" do |s|
      s.gsub! Formula["urdfdom"].prefix.realpath, Formula["urdfdom"].opt_prefix
      s.gsub! Formula["urdfdom_headers"].prefix.realpath, Formula["urdfdom_headers"].opt_prefix
    end
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
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-std=c++11", "-o", "test"
    system "./test"
  end
end
