class CgalQt5 < Formula
  desc "GUI components for the CGAL library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-5.0.2/CGAL-5.0.2.tar.xz"
  sha256 "bb3594ba390735404f0972ece301f369b1ff12646ad25e48056b4d49c976e1fa"

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "qt"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_FLAGS='-std=c++14'
      -DWITH_CGAL_Qt5=ON
    ]

    args_qt5 = %w[
      -DCOMPONENT=CGAL_Qt5
      -P
      cmake_install.cmake
    ]

    system "cmake", ".", *args
    system "cmake", *args_qt5
  end
  test do
    # https://doc.cgal.org/latest/Triangulation_2/Triangulation_2_2draw_triangulation_2_8cpp-example.html
    (testpath/"surprise.cpp").write <<~EOS
      #include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
      #include <CGAL/Triangulation_2.h>
      #include <CGAL/draw_triangulation_2.h>
      #include <fstream>
      typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
      typedef CGAL::Triangulation_2<K>                            Triangulation;
      typedef Triangulation::Point                                Point;
      int main() {
        std::ifstream in("data/triangulation_prog1.cin");
        std::istream_iterator<Point> begin(in);
        std::istream_iterator<Point> end;
        Triangulation t;
        t.insert(begin, end);
        CGAL::draw(t);
        return EXIT_SUCCESS;
       }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1...3.15)
      find_package(CGAL COMPONENTS Qt5)
      add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS)
      add_executable(surprise surprise.cpp)
      target_link_libraries(surprise PUBLIC CGAL::CGAL_Qt5)
    EOS
    system "cmake", "-L", "-DQt5_DIR=#{HOMEBREW_PREFIX}/opt/qt/lib/cmake/Qt5", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
  end
end
