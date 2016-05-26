require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.0.tar.gz"
  sha256 "9bdf9039877402f914f1f7127cc82bec43128508f199e31a5edd4b6f4555b840"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d3f78552bed6846ad03156958ff91ed6490b9c7cbbe7d89647da8efc0d1a2d83" => :el_capitan
    sha256 "5a77f55ae3adc4e0bac5a6e6b7a3bfcdec49d130376c6902bb9de63dac2fc76a" => :yosemite
    sha256 "88265090cd44dd06abf52b67ee621544a72129f6de26c4e90fc63c94206ff02d" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<-EOS.undent
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
