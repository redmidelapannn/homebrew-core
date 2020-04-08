class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.0.tar.gz"
  sha256 "5300f29d9fb8bb466efbc34c01f0045ed0f616278907e507ccd8c2afdea331c8"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "c46b4c7f8d27b772f975608b840060187c26454a8ba83aaea4db05a29908c10f" => :catalina
    sha256 "27838ccfa713060c96e76920718c07e66ab1baea63850ec9b3b6dc8d1a07ba2b" => :mojave
    sha256 "f9eb88f2e476d3884628419e9338af6cc8829cb2b5b3d8102485153caa5bdd67" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DBUILD_OPENNI2_DRIVER=ON"
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
