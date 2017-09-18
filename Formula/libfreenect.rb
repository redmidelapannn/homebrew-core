class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.6.tar.gz"
  sha256 "5ec1973cd01fd864f4c5ccc84536aa2636d0be768ba8b1c2d99026f3cd1abfd3"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "160c24385b53d8f9c463067f4c549daf964b808d1c59c728bee46af0e634cbb5" => :sierra
    sha256 "b0d69ee2eda1b139d05324783a3cdace98bd0a4533cd6f15396a6f233517b48f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  HAS_PYTHON2 = true
  if MacOS.version <= :snow_leopard
    depends_on :python => :optional
    HAS_PYTHON2 = build.with? :python
  end

  depends_on :python3 => :optional
  HAS_PYTHON3 = build.with? :python3

  if HAS_PYTHON2 || HAS_PYTHON3
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"
    args << "-DBUILD_PYTHON2=#{HAS_PYTHON2 ? "ON" : "OFF"}"
    args << "-DBUILD_PYTHON3=#{HAS_PYTHON3 ? "ON" : "OFF"}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
