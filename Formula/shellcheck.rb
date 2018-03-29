require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.7.tar.gz"
  sha256 "3fd7ebec821b96585ba9137b7b8c7bd9410876490f4ec89f2cca9975080a8206"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ef919c94963d534bbb6d9c737396cac07c89b17f8caf0cfd416b119f5f540c3" => :high_sierra
    sha256 "ca99bd8a4ae4e7538fa030e29857c74b9865195115e6d09498bae5b89eb19af8" => :sierra
    sha256 "007e6d9639ae568875ed06d3b9edfc920acaa6e571abd01c7068979a16af9698" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
