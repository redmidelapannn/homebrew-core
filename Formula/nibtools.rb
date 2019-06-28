class Nibtools < Formula
  desc "Commodore 1541/1571 disk image nibbler"
  homepage "https://c64preservation.com/dp.php?pg=nibtools"
  url "https://c64preservation.com/svn/nibtools/trunk", :using => :svn, :revision => "649"
  version "2014"
  sha256 "4e4bb0d2872084ae45d208ccf0868e1901fab99eb17e972e2f0351de63ac840a"

  bottle do
    cellar :any
    sha256 "60331d8ade2809ddec28b83d3cbd4f0e12cdff3e60cb50707b9e610ed739a733" => :mojave
    sha256 "8f893bba17462ee3387db9f21a1f254e6c3d1c4c2753e6b066431e4f6429932c" => :high_sierra
    sha256 "851a16f3a77aad326a72425ceffb8560815281d14e3943dad2e412c542a44720" => :sierra
  end

  depends_on "cc65" => :build
  depends_on "opencbm" => :build

  def install
    system "make", "-f", "GNU/Makefile", "linux"
    mkdir bin.to_s
    cp %w[nibread nibwrite nibconv nibscan nibrepair nibsrqtest], bin.to_s
  end

  test do
    system "#{bin}/nibread", "--help"
  end
end
