require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.3.1.tar.gz"
  sha256 "f07b759cff649240f1bc5e8c89fe330e36c71d5e642920551271957f585b62a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec7117df0619040707e9cff5179f0b006056d5e0a8b7cd2a3da8e5c3f1e701f1" => :high_sierra
    sha256 "3ecd622df4ad3a9a6169583227f491f061184fc8f566b4c80b848471cfdff487" => :sierra
    sha256 "c6a7773d4d58f6fa478233ed881f3efc8ac8ea15acb601b018e38d22e3565396" => :el_capitan
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
