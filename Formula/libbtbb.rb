class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2018-08-R1.tar.gz"
  version "2018-08-R1"
  sha256 "86c5f0c432ae36fd4e69be20e6422ef408c71b2fd2f536786a9cb726c1c28ef0"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "bbec306e4b2331bea56c78a34b58c26bda9fd9934d74b37da0f66f07e2447117" => :mojave
    sha256 "9c618053e9402ad3b96b016905dda2aa4a187202b161307c65146d0af2d9ce5b" => :high_sierra
    sha256 "7e054b8afbee98c21b9573ddaa926d809ac159894ef9f4fdcf18b34cb94ba302" => :sierra
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
