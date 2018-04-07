class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  stable do
    url "https://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2"
    sha256 "dd254beb0bafc695d0f62ae1a222ff85b52dbaa3a16f76e781dce22d0d20a4a6"

    # Fix "CMake Error: CMAKE_Fortran_COMPILER not set, after EnableLanguage"
    # Upstream commit from 20 Jun 2017 "Make sure CMAKE_Fortran_COMPILER is set
    # before checking for Fortran functions"
    patch do
      url "https://bitbucket.org/eigen/eigen/commits/dbab66d00651bf050d1426334a39b627abe7216e/raw"
      sha256 "04b679525437f2a7672ed51ef864cf7ddffa61ce2025035d2355bc065d962823"
    end

    # Remove for > 3.3.4
    # Upstream commit from 6 Apr 2018 "Fix cmake scripts with no fortran compiler"
    patch do
      url "https://bitbucket.org/eigen/eigen/commits/ba14974d054ae9ae4ba88e5e58012fa6c2729c32/raw"
      sha256 "5e4977b195f0199243ec7b78f1398596108d7969dfba02ada41f26ce2c76e244"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "588444ae828ff5c489be397b911608b0292f1032b205776aa02bd51578d36086" => :high_sierra
    sha256 "588444ae828ff5c489be397b911608b0292f1032b205776aa02bd51578d36086" => :sierra
    sha256 "588444ae828ff5c489be397b911608b0292f1032b205776aa02bd51578d36086" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end
