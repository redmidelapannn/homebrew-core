class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.13.0.tar.gz"
  sha256 "1df490a197634d3aab0a65687decd362912869c85a61090ff66f073c967a7dcd"
  revision 4
  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5b5668ce76757f7dfce76b90a8f83b234298e93d9cc1de104b7953c5f2f0c195" => :high_sierra
    sha256 "ce95c0c65bc62075e8bc864cefe8892e049de0d1cb6c77ccaeef52997102bcff" => :sierra
    sha256 "13f3807acfbae69a4391db5a71168ea44e923d7dd5be66644fd9feb18638a71c" => :el_capitan
  end

  devel do
    url "http://ceres-solver.org/ceres-solver-1.14.0rc1.tar.gz"
    sha256 "44c9fde3416688c1804188a9c15dcd4b3cfdf7cb27ee29c5f3b7531b23e122d9"
  end

  depends_on "cmake" => :run
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
                    "-DGLOG_LIBRARY_DIR_HINTS=#{Formula["glog"].opt_lib}"
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
    assert_match "CONVERGENCE", shell_output("./helloworld", 0)
  end
end
