class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.4.tar.gz"
  sha256 "daeee4cf5ab7e9722f3072aa5e0de7340d1ba4fd4be413ec6d5eac210104e053"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    revision 1
    sha256 "3d0215353a8dc7285444720582d9d4bb9750830cca16d713052aed770579b45a" => :el_capitan
    sha256 "64df89efffd05f7bdc968bf79be8d843ac54d2722b2bb8faba84a29ce60e3805" => :yosemite
    sha256 "43e9150c3afe1882254cb270fbd228f684e5ab200b8eea01c2dbb9a04a9b8ae3" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
