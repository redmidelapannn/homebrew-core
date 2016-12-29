class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_1.7.9.tar.gz"
  url "https://gmic.eu/files/source/gmic_1.7.9.tar.gz"
  version "1.7.9.0.2016.12.02"
  sha256 "152f100eb139a5f6e5b3d1e43aaed34f2b3786f72f52724ebde5e5ccea2c7133"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "4513c5e38c030b7f005c851b311c65113cf826da3a5c69f2cc16420e3381b556" => :sierra
    sha256 "cb80f2701b66bb2b2dd8ac4389e7172ce4a98e76a25659194c03f81c004c170b" => :el_capitan
    sha256 "e4cbabbce0142a8a53b1c580492bd966c5f17778a791e52d2b61b3cf6f51c5e5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "fftw" => :recommended
  depends_on "homebrew/science/opencv" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libtiff" => :optional
  depends_on "openexr" => :optional

  def install
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
