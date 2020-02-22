class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.9.2/c/avro-c-1.9.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.9.2/c/avro-c-1.9.2.tar.gz"
  sha256 "08697f7dc9ff52829ff90368628a80f6fd5c118004ced931211c26001e080cd2"

  bottle do
    rebuild 1
    sha256 "a5ca8a1e35c02f6cd418a86264bd08721ee6b592817000d2dbb2328d3c1066ce" => :catalina
    sha256 "3f788be27d062fec7b6f669c341011852912cda72a53282aabc884a5bb149f4f" => :mojave
    sha256 "ffc8eb7f73c380b7b29a894d12791fd484c92b7c77e3b995a8b77caa1b8cc9be" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
