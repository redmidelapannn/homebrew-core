class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.5.tar.gz"
  sha256 "0d7fd69da254f3624848a31c3041dcb8b714a84110b5b6bbb59498c4ffdeafde"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f407cdf0e6e83c96a7b7a82323e80312a9a6ceaaad46e801452d307ca7eb4ad2" => :sierra
    sha256 "cb5febef8c54ee0bf3f11b073df0b2d367032211e4779b2fba6b7d748ac95f7e" => :el_capitan
    sha256 "d127aab68930e2eba22be0eca6b611fdc0963bdb88ba4118d009b7a1bf0ae612" => :yosemite
  end

  option :universal
  option "with-opencv", "Build with OpenCV support"
  option "with-opencv3", "Build with OpenCV 3 support"
  option "with-python", "Build with Python support"
  option "with-python3", "Build with Python 3 support"

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "opencv" if build.with? "opencv"
  depends_on "opencv3" if build.with? "opencv3"
  depends_on "python" if build.with? "python"
  depends_on "python3" if build.with? "python3"

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"
    args << "-DBUILD_CV=ON" if build.with? "opencv" or build.with? "opencv3"
    args << "-DBUILD_PYTHON2=ON" if build.with? "python"
    args << "-DBUILD_PYTHON3=ON" if build.with? "python3"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
