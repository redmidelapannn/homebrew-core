class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "http://www.dettus.net/dhex/"
  url "http://www.dettus.net/dhex/dhex_0.69.tar.gz"
  sha256 "52730bcd1cf16bd4dae0de42531be9a4057535ec61ca38c0804eb8246ea6c41b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4227c87e7830d06a8634ce87a15c935596d7a29d051f4ad1ddf0c45bf9f406d3" => :mojave
    sha256 "749b905cdb51713ea2cfbc8ceceaf5bb2c569bc1196a0229d586698c549b5522" => :high_sierra
    sha256 "133636389b472224c6d12f8082be088464e256d7d108ef33f94f3e4e034086cf" => :sierra
    sha256 "78d10f5fc83e4c46f4c6fbe46df834498118b80f190b2b40d1093630be3e039b" => :el_capitan
    sha256 "c6d92d8f4175ecd84be55b071887a97c7924977fbd24509162c956d17d85c84e" => :yosemite
    sha256 "de8a9b04e49e85b4cca75050375724076c9e496a124b0af49006d60fe44dc81f" => :mavericks
  end

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
