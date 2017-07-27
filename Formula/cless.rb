require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://github.com/tanakh/cless/archive/0.3.0.0.tar.gz"
  sha256 "382ad9b2ce6bf216bf2da1b9cadd9a7561526bfbab418c933b646d03e56833b2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6c7f44171f7a2042f82c4e8bc3d29cc69ca280da8c65495e907d9c270f05c3d6" => :sierra
    sha256 "a47481b697883664ac8239939fd7f6aa59db7b9086b02f9c423ebc14aa153423" => :el_capitan
    sha256 "b9abf3532c9a9f084f00045a2eaf6c8cca4a34ab543c78f585e1d9b773d6c8c8" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # GHC 8 compat
    # Reported 25 May 2016: https://github.com/tanakh/cless/issues/3
    # Also see "fix compilation with GHC 7.10", which has the base bump but not
    # the transformers bump: https://github.com/tanakh/cless/pull/2
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
