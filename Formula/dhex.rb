class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "http://www.dettus.net/dhex/"
  url "http://www.dettus.net/dhex/dhex_0.69.tar.gz"
  sha256 "52730bcd1cf16bd4dae0de42531be9a4057535ec61ca38c0804eb8246ea6c41b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "24526bd9b92f34337f3dfcdd9a163a9cc66ddc092aaabec9585eacf17e281264" => :mojave
    sha256 "478f129d522dd60c684515c36600238040fe767f0761087a5b5f576d63190373" => :high_sierra
    sha256 "f14b40c1962a5737163ef5b4a382ff0a4d42d7f29d14d1895138d1cdefe798fe" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    inreplace "Makefile", "$(DESTDIR)/man", "$(DESTDIR)/share/man"
    bin.mkpath
    man1.mkpath
    man5.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    assert_match("GNU GENERAL PUBLIC LICENSE",
                 pipe_output("#{bin}/dhex -g 2>&1", "", 0))
  end
end
