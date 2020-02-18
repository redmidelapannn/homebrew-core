class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.14.0.tar.gz"
  sha256 "4744005fc3b902fed886ea418df70690caa8e2ff6b5a90f3dd88a3d291ef8e8e"
  revision 10
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "ce9a8a161e5c1bfb4100f6dbcecc69876ba8cda205a95db1cad6580588e785ed" => :catalina
    sha256 "0f256fd303ec79a79ba22a2fa5021bf9270514a5d3d56b338b7823c7bfc20a27" => :mojave
    sha256 "7fb44f11f3a925f3f87b2d67c3604f374f67b42841d4dd8526cd4a8b30e9732b" => :high_sierra
  end

  depends_on "cmake"
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                    "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.dylib",
                    "-DGLOG_INCLUDE_DIR_HINTS=#{Formula["glog"].opt_include}",
                    "-DGLOG_LIBRARY_DIR_HINTS=#{Formula["glog"].opt_lib}",
                    "-DTBB=OFF"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html" unless build.head?
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
