class Ttnctl < Formula
  desc "The Things Network Control Utility"
  homepage "https://www.thethingsnetwork.org/docs/network/cli/"
  url "https://ttnreleases.blob.core.windows.net/release/v2.5.3/ttnctl-darwin-amd64.tar.gz"
  version "2.5.3"
  sha256 "c913ff2db1e49d30539057a707d31443bd95d484d3433545cac5b09b7a915f75"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4868898ab9b780b2acdc13a88d1e73c93fd17c473c66c17cfeec56f959ad838" => :sierra
    sha256 "d9c25d4a12c6701c325ab75433b770403aad4264e00173b9ded87bfa271e8b77" => :el_capitan
    sha256 "d9c25d4a12c6701c325ab75433b770403aad4264e00173b9ded87bfa271e8b77" => :yosemite
  end

  def install
    bin.install "ttnctl-darwin-amd64"
    mv "#{bin}/ttnctl-darwin-amd64", "#{bin}/ttnctl"
  end

  test do
    system "#{bin}/ttnctl", "version"
  end
end
