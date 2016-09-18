require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.19.3.tar.gz"
  sha256 "4f1b7ce4fa6f1efa39fd0388204d24d82b9293e8cf1087b2790013a350bbd26f"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    rebuild 1
    sha256 "402445ed7f5c474c3ee64c40dd6ed6154be52e3760c29648b47fd2564183e6af" => :sierra
    sha256 "03216d3331fada4a7f83d45e3185dbcef14df712a06053dc99c06de9b60294f7" => :el_capitan
    sha256 "c466ee536757187876e1584c2d8d1324a3ee593e8b39f24ca2eb8a193b4e8494" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
