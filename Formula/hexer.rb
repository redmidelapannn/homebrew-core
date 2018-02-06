class Hexer < Formula
  desc "Hexbin density and boundary generation"
  homepage "https://github.com/hobu/hexer"
  url "https://github.com/hobu/hexer/archive/1.4.0.tar.gz"
  sha256 "886134fcdd75da2c50aa48624de19f5ae09231d5290812ec05f09f50319242cb"
  bottle do
    cellar :any
    sha256 "c873ff96a813f2d68e9b2d211cf468d858200f672f175d561defa1c02830e536" => :high_sierra
    sha256 "5d25e5180c443265f3c62d88653f43cf3c5c88b76e8cdfa4446f3737517033ed" => :sierra
    sha256 "34616294f8bf72df5748c26890c1a5576d03abe83d061f1b7d4956c28f9628c8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
  test do
    system bin/"curse", "-c", "hex", "-i", "fake_file"
  end
end
