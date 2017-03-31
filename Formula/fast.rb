class Fast < Formula
  desc "Flattening Abstract Syntax Trees"
  homepage "https://github.com/yijunyu/fast"
  url "https://github.com/yijunyu/fast/archive/v0.0.1.tar.gz"
  version "0.0.2"
  sha256 "844467051325cee43ba98b52e9512133ec53388153b32339190509b82570a4e9"

  bottle do
    cellar :any
    sha256 "a8677561cd7ab66b32b3130d851d4f686e059aa556f867b91d54ab7d2b09fbc0" => :sierra
    sha256 "536f614f52220766f22a5b6b4a116d301e5b21291745d088027064e347717d6c" => :el_capitan
    sha256 "efdbfdee96a93eddb08c6d99549447ab7e4eda8ac4cd50477bdee3c06effbff5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "srcml" => :optional

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
