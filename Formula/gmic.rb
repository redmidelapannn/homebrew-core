class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.0.3.tar.gz"
  sha256 "b1f65aba4aa76bdf6da1ad923018de6844f5b76f9974978b4b12be108f87261e"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f59a935272cf758a6734b3e3c28d402b42ec64e43365d63a11a213ea0cc57d2d" => :sierra
    sha256 "b4526597b2789d0f6a0ccd2fdac239e9f7fdbeaf9e377c82d4117cfd25b3e2eb" => :el_capitan
    sha256 "ae46b8835844a7c7e0c402eb6db117760314fb51c02ba8bc24f3e23af3b44dd3" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "fftw" => :recommended
  depends_on "opencv@2" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libtiff" => :optional
  depends_on "openexr" => :optional

  def install
    cp "resources/CMakeLists.txt", buildpath
    args = std_cmake_args
    args << "-DENABLE_X=OFF"
    args << "-DENABLE_JPEG=OFF" if build.without? "jpeg"
    args << "-DENABLE_PNG=OFF" if build.without? "libpng"
    args << "-DENABLE_FFTW=OFF" if build.without? "fftw"
    args << "-DENABLE_OPENCV=OFF" if build.without? "opencv"
    args << "-DENABLE_FFMPEG=OFF" if build.without? "ffmpeg"
    args << "-DENABLE_TIFF=OFF" if build.without? "libtiff"
    args << "-DENABLE_OPENEXR=OFF" if build.without? "openexr"
    system "cmake", *args
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
