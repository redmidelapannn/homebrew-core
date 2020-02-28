require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.2/darcs-2.14.2.tar.gz"
  sha256 "65d160a43874960dcba114c0b74d9c7b25d098486f515655502f42ff0c22a27e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c78d47a90fab464bbe55e56e5e63e64fbac954dce2afcf32af49224d0a8262ca" => :catalina
    sha256 "53f8eeb55274d89f3753e4226fd95c53737e522e215d8d28fd4c334ccd680100" => :mojave
    sha256 "9e7cf37105322dad731f88e44700006fce01f5dd3e84711e84b1013eda854211" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "gmp"

  def install
    install_cabal_package
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
