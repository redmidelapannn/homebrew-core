class Sjasmplus < Formula
  desc "SJAsmPlus: Z80 cross-assembler"
  homepage "https://github.com/sjasmplus/sjasmplus/wiki"
  url "https://github.com/sjasmplus/sjasmplus/archive/20190304.tar.gz"
  sha256 "cea408eb3019d9f09af1996654e959ae97d7d1b4d7561655f3305f701d0f2286"
  bottle do
    cellar :any
    sha256 "ba2202d772d7eecf24d96ea2985a3bc89dd71aba8df179ff9a477ed9e8aa0445" => :mojave
    sha256 "37b545840630b113cc531ed35c7866153edfa07ef5f05f3f5d7f2f6ab927bf98" => :high_sierra
    sha256 "4c95ab7b1cec580773ffa925786156704558ef0e27acac15a9a63bbe76eb6a0b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "sjasmplus"
  end

  test do
    system "true"
  end
end
