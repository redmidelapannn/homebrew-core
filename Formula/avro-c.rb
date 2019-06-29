class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.0/c/avro-c-1.9.0.tar.gz"
  sha256 "80568644384828b7f926efe76965907c8fff0c49e02301bfe8b2cb7965fa08b2"

  bottle do
    rebuild 1
    sha256 "a7189199ac9c54216b81278bb20f56243c98a276934b03b630f137d35fdc51b5" => :mojave
    sha256 "7711830f2dc159938f5b074edb80f7c6161cd7208d2f0cb43231f3b48350b6fe" => :high_sierra
    sha256 "4735fc0a5d163ad3f730cc9067ff255959ee86b4a24402d01c55c94cb397f2c8" => :sierra
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
