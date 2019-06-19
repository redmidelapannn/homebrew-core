class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.19.4.tar.gz"
  sha256 "ea0ed42ac27888f4e4acaf99367fbef714373fa586f204e8bc22b8e5335ecf06"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f8024d03da565fec6ddd1e91734bf65ca33b29165f348008f8f15b2243a108f" => :mojave
    sha256 "1f8024d03da565fec6ddd1e91734bf65ca33b29165f348008f8f15b2243a108f" => :high_sierra
    sha256 "4c2b8a79e8050ddcbe1701ee34b5331bbf69d9f8f18b4b30f6ac2a3ff33c74c7" => :sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.5.4.tar.gz"
    sha256 "35478bb08949d0c36d4cf24cabbaa8322c507f8247cc69e017bddb2e28ffaf15"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensor/xarray.hpp"
      #include "xtensor/xio.hpp"
      #include "xtensor/xview.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
