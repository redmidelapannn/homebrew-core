class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha256 "62652a4dd024e366f41042c281e5a3359a09f33760eb1af660f950ab9e70f1f7"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    cellar :any
    rebuild 3
    sha256 "4f8fdc3bd23ecc4248eecbfce3e0ecb85508d8b80919a98d56f2cd6434603ea1" => :el_capitan
    sha256 "5a75866c2bb0e67b7f52e7d0ba300921eefc8ad1ce8974b259ba3772124e5bf0" => :yosemite
    sha256 "e13cc186a262156f56f03d7f0e683530278cf83d943dea883bd407e44f7e31e9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "jpeg" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
