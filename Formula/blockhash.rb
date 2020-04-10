class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.1.tar.gz"
  sha256 "56e8d2fecf2c7658c9f8b32bfb2d29fdd0d0535ddb3082e44b45a5da705aca86"
  revision 1
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bc0522958217e8cbe8111eb40c8ad78907a860669ce595e99d4d52a24b878a13" => :catalina
    sha256 "b5ee8dc5d0e2ca9505776e2c95f3676caf25a7eb146e47f6decbbb02377785f0" => :mojave
    sha256 "ddb7ff3633322309c4ea54f215972958802fe0e1f0b676249883ee396274504e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on :macos # Due to Python 2

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
