class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "https://asciitex.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a9dabc10298e28b931595bd3c655dc7a2e0ab09955f5aa0e0cf4acb5c968091" => :sierra
    sha256 "933563dd4e695e273089ac6b4e3f4de09e912378e85b1165762a82143d80f529" => :el_capitan
    sha256 "8625762f1710a332e607d575bb4d46b258a370298903b905cfc16ec9a0747207" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace "Makefile", "man/asciiTeX_gui.1", ""
    system "make", "install"
    pkgshare.install "EXAMPLES"
  end

  test do
    system "#{bin}/asciiTeX", "-f", "#{pkgshare}/EXAMPLES"
  end
end
