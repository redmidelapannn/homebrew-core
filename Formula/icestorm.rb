class Icestorm < Formula
  desc "Bitstream Tools for Lattice iCE40 FPGAs"
  homepage "http://www.clifford.at/icestorm/"
  url "https://github.com/cliffordwolf/icestorm/archive/9671b760f84ca4006f0ef101a3e3b201df4eabb5.tar.gz"
  version "20181109"
  sha256 "583f8fafe21e0d69e730316a7d36459e6d49506d6557a8b11e1d048868a6c16f"
  bottle do
    cellar :any
    sha256 "a33175e2b702a910eccc104ecd5ca15d38fb7f5a78d03fd375c39dfc560321fa" => :mojave
    sha256 "32a8323f0a083f0e3f83927f50b3e82a11541e86519ff1c8a5be8677bf4eb9ee" => :high_sierra
    sha256 "31c8a214a19f0f9012ed845c4af936d1ab4dbe17f72680056e538371f520ccb3" => :sierra
  end

  # head "https://github.com/cliffordwolf/icestorm.git"

  depends_on "pkg-config" => :build
  depends_on "libftdi0"
  depends_on "python"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/iceprog", "--help"
  end
end
