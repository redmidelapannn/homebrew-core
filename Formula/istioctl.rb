class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/releases/download/1.0.5/istio-1.0.5-osx.tar.gz"
  sha256 "98043349092853796d2eb2709df0bfd029689ffcc70c451dce04ec45f5fabc83"

  bottle do
    cellar :any_skip_relocation
    sha256 "23e39dde3a88dbad9698a38e0d73dca1e75266bcba08c31932159e117aeee590" => :mojave
    sha256 "ea5b344d5a35af120359a65df358ec570a42059a75dd75b34ddf36b83d2873de" => :high_sierra
    sha256 "ea5b344d5a35af120359a65df358ec570a42059a75dd75b34ddf36b83d2873de" => :sierra
  end

  def install
    bin.install "bin/istioctl"
  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
