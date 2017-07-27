require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.6.tar.gz"
  sha256 "1c3cd8995ebebf6c8e5475910809762b91bebf0a3827ad87a0c392c168326de2"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30f5b24aeb2542a303a1e42600f820e06ebc0d04e73156c9749e6c995931cc6f" => :sierra
    sha256 "eee9601c48001bb2db9157667f9b31b4661e37d102a89966a58aea8ee9be0d36" => :el_capitan
    sha256 "861489852746217de249c3c7a5ce00c647a7322df480997dab3d4aefb72ad67c" => :yosemite
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
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
