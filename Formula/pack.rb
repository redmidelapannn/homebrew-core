class Pack < Formula
  desc "A CLI tool for building applications with Cloud Native Buildpacks"
  homepage "https://buildpacks.io"
  url "https://github.com/buildpack/pack/releases/download/v0.0.9/pack-0.0.9-macos.tar.gz"
  sha256 "6b8ed842d91ddff35f6aa96fefc4ecde767a4ee7a3bdc772eba0a14c123cd47b"

  def install
    bin.install "pack"
  end
end