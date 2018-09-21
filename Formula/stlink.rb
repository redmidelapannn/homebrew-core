class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.5.1.tar.gz"
  sha256 "e0145fbfd3e781f21baf12a0750b0933c445ee6338e36142836bf5a2c267e107"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a044601ff962958f1f61d23d03a3ce3624ed3d1e7c08bf8fc559bcba96e88df0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "gtk+3" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"st-util", "-h"
  end
end
