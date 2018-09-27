class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9ad70c102804e270e8f667b57d3c09246cdefab39cb83c0504feeb88b192218a" => :mojave
    sha256 "94339668ceae791bba44f3c71304cfc9e0a9e0c5cea0c120fd096d8f2f2c6f92" => :high_sierra
    sha256 "216443282b77c4f063999a11e447b8cc64cc67c380b8fbb482236fdcc0fef85b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y"
    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
