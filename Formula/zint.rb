class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://zint.github.io/"
  url "https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz"
  sha256 "de2f4fd0d008530511f5dea2cff7f96f45df4c029b57431b2411b7e1f3a523e8"
  revision 2

  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e1ff98e1e4986e7baf868e95a5e954d1f9e0bd9600ca90ec9e277187c0de763a" => :sierra
    sha256 "1798ccb41d79f1e0fd9f23cb1b82dcb7e06cb565e658c2fbe750fe39e445a9bd" => :el_capitan
    sha256 "003f2543ca3a5013393d19f9f7166c92c2dcc0eafec1df48f24d095c6829b6ec" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
