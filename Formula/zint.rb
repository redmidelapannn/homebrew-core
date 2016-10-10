class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://zint.github.io/"
  url "https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz"
  sha256 "de2f4fd0d008530511f5dea2cff7f96f45df4c029b57431b2411b7e1f3a523e8"
  revision 2

  head "git://zint.git.sourceforge.net/gitroot/zint/zint"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cccd06eb8c3bc32a791bdf994598ba45856bcd110d98127daf266f3567a0edd7" => :sierra
    sha256 "0f90d6997be5bcf384979051d01f1400a855fd339db2f3ad94022ae8a7f3c022" => :el_capitan
    sha256 "3130a5d273a3fb5476f0697ae6841a15e473f34c68b083f0884b7e5cc248ec14" => :yosemite
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
