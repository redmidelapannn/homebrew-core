class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.2/c/avro-c-1.9.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.9.2/c/avro-c-1.9.2.tar.gz"
  sha256 "08697f7dc9ff52829ff90368628a80f6fd5c118004ced931211c26001e080cd2"

  bottle do
    rebuild 1
    sha256 "6715e37b4b22201679df4ef942665b0374351591611db7b43e67e720b6e5905d" => :catalina
    sha256 "be373d26cf311cb80a6a6e4c958df7c356f537c091515199314922bd3f52c007" => :mojave
    sha256 "245f91cb0c19a60c0372114639cff87889e9be9656a68f695db5f9705a22d5a9" => :high_sierra
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
