class CloudNuke < Formula
  desc "Cleaning up your cloud accounts by nuking all resources in it"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.1.4/cloud-nuke_darwin_amd64"
  version "0.1.4"
  sha256 "eaf6cdc9d7590f1db4c3c266dd8ba29e04877082cfd06d372602045aafeee5a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d0da1ba9c94101f2b0cf768fa003c3ae41953e46b43e24a9f742ffd1c1db8e1" => :mojave
    sha256 "e43af72c5a44b09e297c7d80b797dd1be001e0d7891c28238993faacd1860abe" => :high_sierra
    sha256 "e43af72c5a44b09e297c7d80b797dd1be001e0d7891c28238993faacd1860abe" => :sierra
  end

  def install
    bin.install "cloud-nuke_darwin_amd64"
    mv bin/"cloud-nuke_darwin_amd64", bin/"cloud-nuke"
  end

  test do
    assert_match "cloud-nuke version v0.1.4", shell_output("#{bin}/cloud-nuke -v ")
  end
end
