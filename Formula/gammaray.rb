class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.7.0/gammaray-2.7.0.tar.gz"
  sha256 "09b814a33a53ae76f897ca8a100af9b57b08807f6fc2a1a8c7889212ee10c83b"
  revision 1
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    rebuild 1
    sha256 "f497e8063375d617a6754550fdae7aef818ec8a32ee3244f6f10f188a6e45cec" => :sierra
    sha256 "56b389d3a615853d7b8ad4ff2e2a18feef6029a0af1e2d59dc940926657fd2aa" => :el_capitan
    sha256 "0ed0139932eb9005b0abb6860bf635c35f5ee60ea8c053c78bc73812b57d786a" => :yosemite
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, "with-qt5"]

  def install
    # For Mountain Lion
    ENV.libcxx

    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + (build.without?("vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + (build.without?("graphviz") ? "ON" : "OFF")

    system "cmake", *args
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
