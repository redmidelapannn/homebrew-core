class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2018-08-R1.tar.gz"
  version "2018-08-R1"
  sha256 "86c5f0c432ae36fd4e69be20e6422ef408c71b2fd2f536786a9cb726c1c28ef0"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "94949c6626fc47d9879b00ab5f259a3bc09ffa3aab3b9be93c56e80cdb19d5db" => :mojave
    sha256 "e044f611d480089eb2206cfdb6d7289c33cd9043642f024270957e6ac3f2fa5f" => :high_sierra
    sha256 "ce36c7d48d1ca6ebf1087f2edab17be8ce4f381afe652f03a5fab0d6f6c9f7db" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
