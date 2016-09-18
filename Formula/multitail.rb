class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.4.2.tgz"
  sha256 "af1d5458a78ad3b747c5eeb135b19bdca281ce414cefdc6ea0cff6d913caa1fd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ca668542d335838703a1f112af8ffaecdaf766e3fd8f7b6bdc5f772f45194529" => :sierra
    sha256 "7ed8b9443e77afb594d7d9518aa7c54177c54d62ce638d579db7d7b803d1de45" => :el_capitan
    sha256 "d724a13108880691b93026dd1efcb6d61d2cc2d8f216fbc9c7095fd9e603eb57" => :yosemite
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
  end
end
