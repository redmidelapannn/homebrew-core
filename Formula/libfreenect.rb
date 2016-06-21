class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.1.tar.gz"
  sha256 "97e5dd11a0f292b6a3014d1a31c7af16a21cd6574a63057ed7a364064a7614d0"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    revision 2
    sha256 "3ac390bc778627a3a92febdf1a9c8439417e5291367ca3d3d042e2edcb6781c2" => :el_capitan
    sha256 "51b08746c38c43591cdeb1be6b71e5d546c118b35e0675d4a4f0cff2378f1818" => :yosemite
    sha256 "ada48c982bc4e2425ddea8960815bb3290181c9599e85732af4cb8f6f91200c4" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"

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
