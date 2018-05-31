require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.0/darcs-2.14.0.tar.gz"
  sha256 "19fa0882a1485f03ab0552d6f01d538c2b286c4a38a1fe502e9cf2a78f782803"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bdb079f4e20e6d81c95cfe880cbda3165225e75a07cb0468d443a918dbde676f" => :high_sierra
    sha256 "6cee893139016febd6d1b1eb27a78ea3eabc1d15b6918d01e459fbcd817ee5e2" => :sierra
    sha256 "ab7fe132ed3bbdd34fa268c0ffa754d7a18468b6eabbf8a4da4feeb091236c1a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  def install
    # GHC 8.4.x compatibility; remove the extra arguments for darcs > 2.14.0
    install_cabal_package "--allow-newer=darcs:async",
                          "--constraint", "async < 2.3",
                          "--allow-newer=darcs:graphviz",
                          "--constraint", "graphviz < 2999.20.1"
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
