class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/advancemenu-2.9/advancemenu-2.9.tar.gz"
  sha256 "c7599da6ff715eb3ad9f7a55973a9aaac2f26740a4e12daf744cf08963d652c1"

  bottle do
    rebuild 1
    sha256 "fbc06e526158689320a0910e97dfc52f3a29f342aba9576aad786e5832e64041" => :high_sierra
    sha256 "d1f62b2e2e0c912f26df937c93ba00975762580c029a4a0878be12a647269d7c" => :sierra
    sha256 "092a18897204d67d37b11f7a017e3fe5de15f36fe52bbf14068eebfd5f5a61dc" => :el_capitan
  end

  depends_on "sdl"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    system bin/"advmenu", "--version"
  end
end
