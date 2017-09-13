class Cgal < Formula
  desc "Computational Geometry Algorithm Library"
  homepage "https://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases/CGAL-4.10.1/CGAL-4.10.1.tar.xz"
  sha256 "2baef1f4cca90dc82851267c36f8632bd6b39e8a5d15c23f1d78b4172d36d743"

  bottle do
    cellar :any
    sha256 "3be28d966243789b5547e702a8df86c98641eeaea54b72a17422e32531aa0150" => :sierra
    sha256 "fa1ecd8d3c53c34e9d595803e399d44583106758834e4dbe0968ad7c8b3113b8" => :el_capitan
  end

  option "with-qt", "Build ImageIO and Qt components of CGAL"

  deprecated_option "imaging" => "with-qt"
  deprecated_option "with-imaging" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "qt" => :optional

  def install
    qt = build.with?("qt") ? "ON" : "OFF"
    system "cmake", ".", *std_cmake_args,
                    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                    "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib",
                    "-DWITH_CGAL_ImageIO=#{qt}",
                    "-DWITH_CGAL_Qt5=#{qt}",
                    "-DWITH_Eigen3=ON",
                    "-DWITH_LAPACK=ON"
    system "make", "install"
  end

  test do
    # https://doc.cgal.org/latest/Algebraic_foundations/Algebraic_foundations_2interoperable_8cpp-example.html
    (testpath/"surprise.cpp").write <<-EOS.undent
      #include <CGAL/basic.h>
      #include <CGAL/Coercion_traits.h>
      #include <CGAL/IO/io.h>
      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
          typedef CGAL::Coercion_traits<A,B> CT;
          CGAL_static_assertion((CT::Are_explicit_interoperable::value));
          typename CT::Cast cast;
          return cast(a)*cast(b);
      }
      int main(){
          std::cout<< binary_func(double(3), int(5)) << std::endl;
          std::cout<< binary_func(int(3), double(5)) << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lCGAL",
                    "surprise.cpp", "-o", "test"
    assert_equal "15\n15", shell_output("./test").chomp
  end
end
