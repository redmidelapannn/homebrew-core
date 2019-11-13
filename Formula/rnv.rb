class Rnv < Formula
  desc "Implementation of Relax NG Compact Syntax validator"
  homepage "https://sourceforge.net/projects/rnv/"
  url "https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2"
  sha256 "b2a1578773edd29ef7a828b3a392bbea61b4ca8013ce4efc3b5fbc18662c162e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c6b244c49e6fd700ac29fc754d7bfafc008f56524bb5e4d9b0b8a98ce8c2641e" => :catalina
    sha256 "f45d599809c019afac6837062556006a8fc1581f3ee37b0e120393d60f76da9b" => :mojave
    sha256 "2af95c556f19752faafd61308eba31b526cd1839df79de21f2f5f2857b27349f" => :high_sierra
  end

  depends_on "expat"

  conflicts_with "arx", "arx-libertatis", :because => "rnv, arx and arx-libertatis all install `arx` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
