require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.3.tar.gz"
  sha256 "3becc8cd5404b0b9651ccc0ec9a3cb2d58ca84194153aa7530a424cc9a55c0fa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "637a4c57bd451e60db8a677c607b0444c231d436e29edf5c7b1e7817460929f5" => :high_sierra
    sha256 "4fbc5d82ebd87d33e20ed5e4c82c30e1ac04144da49d9cd44468f478ccacfd24" => :sierra
    sha256 "565fd1f6194ad6834592e8072ccdcb4a1f842022f088afa7c3c442c754e93261" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove for > 0.2.3; GHC 8.4.1 compat
  # Upstream commit from 25 Mar 2018 "Updates for new Cabal, GHC and base libraries"
  patch do
    url "https://github.com/solidsnack/arx/commit/8ec85a7.patch?full_index=1"
    sha256 "fc40c128c7aeee75e3ddd10b3df8a81e35b6092ad61efdfa968fd84d50355cf8"
  end

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
