require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.2.tar.gz"
  sha256 "47e7a61a009d43c40ac0ce9c71917b0f967ef880c99d4602c7314b51c270fd0f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5250b21772030465832670c6fb35ed92b92659e5c1f932e4b661e74fca91f3c4" => :sierra
    sha256 "6dd525a36a995f3adca3ee6e1747409f08a49e56f99df02a8eb31f5e160ed5b3" => :el_capitan
    sha256 "5bed393e2f02186728d5fd34186d22a0431c1a425a807f8067e3d2d1244bd312" => :yosemite
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"

      system "make"

      tag = `./bin/dist tag`.chomp
      bin.install "tmp/dist/arx-#{tag}/arx" => "arx"
    end
  end

  test do
    testscript = (testpath/"testing.sh")

    testscript.write shell_output("#{bin}/arx tmpx // echo 'testing'")
    testscript.chmod 0555

    assert_match /testing/, shell_output("./testing.sh")
  end
end
