class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.9.1/gammaray-2.9.1.tar.gz"
  sha256 "ba1f6f2b777c550511a17f704b9c340df139de8ba8fa0d72782ea51d0086fa47"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    rebuild 1
    sha256 "c7297b83ba137b3c9d3648654ac8ee3ca421c3df8fa4b9a533e932cd8e7875fc" => :mojave
    sha256 "3a73ae4703aee002cddb72ca3f1cad0a94c7adacf597c0f88543f10eca1a6e3a" => :high_sierra
    sha256 "06d0091ea03abf618fbd26511909bc4b1a0226a4f949215a51854ed599a485ea" => :sierra
    sha256 "bc9ddf7b4402392775dc61fe5f3edc10afa928f91b4b0334eaa6c30bbe154da8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  needs :cxx11

  def install
    # For Mountain Lion
    ENV.libcxx

    system "cmake", *std_cmake_args,
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF"
    system "make", "install"
  end

  test do
    assert_predicate prefix/"GammaRay.app/Contents/MacOS/gammaray", :executable?
  end
end
