class Pack < Formula
  desc "A CLI tool for building applications with Cloud Native Buildpacks"
  homepage "https://buildpacks.io"
  url "https://github.com/buildpack/pack/releases/download/v0.0.9/pack-0.0.9-macos.tar.gz"
  sha256 "6b8ed842d91ddff35f6aa96fefc4ecde767a4ee7a3bdc772eba0a14c123cd47b"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb4108d0ae48bbfd3e5818e160ad2df5bedb8b60442c46299caaca913e050452" => :mojave
    sha256 "cb4108d0ae48bbfd3e5818e160ad2df5bedb8b60442c46299caaca913e050452" => :high_sierra
    sha256 "6a8943f41e0e7e26149ad1cebe5bb8a51c53f5422a2ee6690f32a5e5b2bbba75" => :sierra
  end

  def install
    bin.install "pack"
  end
end