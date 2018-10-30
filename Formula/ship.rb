class Ship < Formula
  desc "Deploy 3rd party applications through modern pipelines"
  homepage "https://ship.replicated.com/"
  url "https://github.com/replicatedhq/ship/releases/download/v0.21.0/ship_0.21.0_darwin_amd64.tar.gz"
  version "0.21.0"
  sha256 "31aff6c15e6b3cf964f724d5e74e4199db57954c2d7650fce03638138c04df6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d5e609a976d65b65a36c39f951e0a3685ab0edf4c1b21b2a68755973228860a" => :mojave
    sha256 "9f31ad70abef06cdc4b6f8258dd28f4e903de0850ee0eff4776185ce9f5947ce" => :high_sierra
    sha256 "9f31ad70abef06cdc4b6f8258dd28f4e903de0850ee0eff4776185ce9f5947ce" => :sierra
  end

  def install
    bin.install "ship"
  end

  test do
    system "#{bin}/ship", "version"
  end
end
