class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2016.06.tar.gz"
  sha256 "6e6333fd0f17e85f968a6180942f889705c4f2ac16507b2f86c80630c55032e8"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    rebuild 1
    sha256 "c46e23d9ee8d1e821f9f10b10b98b5042e73d0d1e2437a2129d1548312fe62ec" => :sierra
    sha256 "57454c24909c207c2a13d85f9a70b161a8895a87206815e578b1d4012ee80c93" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  patch do
    url "https://github.com/Nuand/bladeRF/commit/b6f6267.diff"
    sha256 "c9b80e04e7e6c7b6ddc6ce3944650d6ae9ad30f4187857a84632993fb9ccc39d"
  end

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
