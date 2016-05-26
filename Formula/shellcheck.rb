require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.4.tar.gz"
  sha256 "1f558bf3e2469477e260f8d2edcab381a9b600b01d0f6498f8a2565965d75407"
  revision 1
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "a8b1c86c5348514f4ac5db1546b28078e3b9e88d2cae541f63debdb6a6e950fe" => :el_capitan
    sha256 "05bb476404447a88be5b64f0d1b5c823253fdda69441a29fe254818ab161e854" => :yosemite
    sha256 "aa13d94aa57ea345b82ada1bf3fddac23b5dbb7060417159b049db8616d27f72" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<-EOS.undent
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("shellcheck -f gcc #{sh}", 1)
  end
end
