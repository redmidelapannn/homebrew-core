class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.io"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.0.src.tar.gz"
  sha256 "015a3c2832c7c097d98a5527deef882119546287ba8f2a70c736227d764ef802"

  bottle do
    rebuild 1
    sha256 "a9ab53de233228ec3ffa1a56f6094c986e89dbd4bdb5ad6b0fd60e0d867c72ee" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bvi", "-c", "q"
  end
end
