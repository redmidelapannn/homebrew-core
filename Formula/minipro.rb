class Minipro < Formula
  desc "Free and open TL866XX programmer"
  homepage "https://gitlab.com/DavidGriffith/minipro"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.3/minipro-0.3.tar.gz"
  sha256 "6096ebd683028da5787ecaf4c2c39a52a285371e7384c34c2f10b3583756b48d"

  bottle do
    cellar :any
    sha256 "41d4f7d892d8c0cbdf6e69375997fd5b6019258a98a2e58b0aa9b79a23cca4d0" => :mojave
    sha256 "835b09dfaf914f9891196ea0db7c1ac1d329b796d0c6a25ffc029f9095bc3969" => :high_sierra
    sha256 "2ce694b4a7dac30ebc12f8f1df45393ab2ddde4d44c317a76218a24a2236bb63" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/minipro", "-h"
  end
end
