class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.5.tar.gz"
  sha256 "2f3de90a09bba6d24c89258be016fd6992886bda13dbbcaf03de58c765774845"
  revision 1
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "584f69b615052f0b7c0ddd1d419ad49a14f64f98d4e5a9d0f69e9f9359d1776a" => :mojave
    sha256 "fa3a09ebd7d3d918c9b970202f726cd315a9972117877437ac7eb57ab6e4aeef" => :high_sierra
    sha256 "3df63b5e9c4fd039ec46206fe30c2781a7beb2a67307150a02cc6411a7b78ab1" => :sierra
    sha256 "8cded8089feca91468ec4ab2662274584d10ee165b355a68528646655604189d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ffmpeg" => :optional
  depends_on "libtiff" => :optional
  depends_on "opencv@2" => :optional
  depends_on "openexr" => :optional

  def install
    cp "resources/CMakeLists.txt", buildpath
    args = std_cmake_args
    args << "-DENABLE_X=OFF"
    args << "-DENABLE_FFMPEG=OFF" if build.without? "ffmpeg"
    args << "-DENABLE_OPENCV=OFF" if build.without? "opencv"
    args << "-DENABLE_OPENEXR=OFF" if build.without? "openexr"
    args << "-DENABLE_TIFF=OFF" if build.without? "libtiff"
    system "cmake", *args
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
