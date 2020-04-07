require "language/haskell"

class Cmt < Formula
  include Language::Haskell::Cabal

  desc "Write consistent git commit messages based on a custom template"
  homepage "https://github.com/smallhadroncollider/cmt"
  url "https://github.com/smallhadroncollider/cmt/archive/0.7.1.tar.gz"
  sha256 "364faaf5f44544f952b511be184a724e2011fba8f0f88fdfc05fef6985dd32f6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0e5de1bdad88cead67339414a6cb8b3cbb43d31243c165e2fc17bb5ccd4b658" => :catalina
    sha256 "6d49bb3c2d9b7ce21e79040bf810352c707acb58a6e5f5ed85f902454fdd0edf" => :mojave
    sha256 "6afece89c0830c31b65f5f5ef6b3172c19cdbaf938c2b99d8c342de7ae253bdc" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/".cmt").write <<~EOS
      {}

      Homebrew Test: ${*}
    EOS

    expected = <<~EOS
      *** Result ***

      Homebrew Test: Blah blah blah


      run: cmt --prev to commit
    EOS

    assert_match expected, shell_output("#{bin}/cmt --dry-run --no-color 'Blah blah blah'")
  end
end
