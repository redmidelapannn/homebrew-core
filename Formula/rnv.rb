class Rnv < Formula
  desc "Implementation of Relax NG Compact Syntax validator"
  homepage "https://sourceforge.net/projects/rnv/"
  url "https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2"
  sha256 "b2a1578773edd29ef7a828b3a392bbea61b4ca8013ce4efc3b5fbc18662c162e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b809df0bda73f89815a433d7fc2612b7e26152d36431261b02eb161b5016780f" => :catalina
    sha256 "a33a468e8ef70f6dc450f73fb188e2b87e923ad51e7dd75514eadc050e540179" => :mojave
    sha256 "d1a9b1f67de15887aa5864eef9f71d9a61a76d07f568913c9a1a39d584a91841" => :high_sierra
  end

  depends_on "expat"

  conflicts_with "arx-libertatis", :because => "both install `arx` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
