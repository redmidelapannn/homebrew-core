require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.21.3/hopenpgp-tools-0.21.3.tar.gz"
  sha256 "1411887720962fd6a1101e90c01348d34bb400fbbbc34abe5c2ded5156c7c6a3"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d140c5af01c4d877c2887b40f13365b36d7d387d9007e78cf453bfafbd3fc8b0" => :catalina
    sha256 "bfc54de827000c013aee36639cc7eb497c07cd18add24c5e5ce73470664c4863" => :mojave
    sha256 "12957d94e1f1130e2fe025f8e2fd0813ce1feda83ae9684eba033466f01e86d3" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    install_cabal_package :using => ["alex", "happy", "c2hs"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
