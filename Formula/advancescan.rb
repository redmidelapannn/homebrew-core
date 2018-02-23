class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "08b744ae16118838144a858abff7997408d5c152260b7ad3f023d2a61931b534" => :high_sierra
    sha256 "239939bf76cdaace97bffb6ed94813a9f317761c34426848cb5e98a310ada7a2" => :sierra
    sha256 "b24e212df834977e0c881bdf8a1ab5a4dd0a0bf02e6487715ae2a8179a82981c" => :el_capitan
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/advdiff", "-V"
    system "#{bin}/advscan", "-V"
  end
end
