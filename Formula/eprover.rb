class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.0/E.tgz"
  sha256 "ebd911cb3a8b43019f666ffde10b28ca8e0871ab401ce88d1b9ba276c5c8bcf6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "308f0893cc355e352c542f6e4209a0b822494a293b5ac3661f367a6225ce83b5" => :high_sierra
    sha256 "051c778125801dc38801937d10f5cc53b07a578e0d3ec941a9c4939b4501d571" => :sierra
    sha256 "ac0781cd7faa4c92aa05fa87084bdc88886dbead6b5b923bb37b850b527ee9b2" => :el_capitan
  end

  def install
    inreplace ["PROVER/eproof", "PROVER/eproof_ram"], "EXECPATH=.",
                                                      "EXECPATH=#{bin}"
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
