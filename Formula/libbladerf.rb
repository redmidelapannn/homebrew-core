class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2015.07.tar.gz"
  sha256 "9e15911ab39ba1eb4aa1bcbf518a0eac5396207fc4a58c32b2550fe0a65f9d22"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    revision 1
    sha256 "e55f4ed57180de26bafc72d6eff8815182ea59e7888c8b91274eaef090d26f46" => :el_capitan
    sha256 "dc0f4a737c26257e8c4e01d445a32356554b849e15955ce871d7ef1eafdd1c31" => :yosemite
    sha256 "b2bdde876836fede989813063cc939084ca9276c7b3c1d3db09e327c852e6b3f" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "host/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
