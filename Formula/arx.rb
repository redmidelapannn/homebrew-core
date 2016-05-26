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
    sha256 "bfffe1c1e78fc9c0175b2fb66bdd534b9575d2634a66244acf04e78b317b8055" => :el_capitan
    sha256 "460726a5405b0180be17f1e5cfc289840d3d965924f9bbf8dfdea68cc2bff5c1" => :yosemite
    sha256 "abcc5a92ce896d6e326fffeb6fb0666cf5f880daedf4fc76d4c6b809fa2df375" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
