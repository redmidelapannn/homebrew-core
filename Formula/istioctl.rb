class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio/archive/1.0.5.tar.gz"
  sha256 "48418c5f27ef61403aea79ea57c502cec426117a5de4db713cd3691e2bf91204"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd6d0c456407618bca1b9f1b900d19f5701ab66a0cadeadf2bfe521e99621a75" => :mojave
    sha256 "b7db0d8ee23ef6be0cefd9b170dea1b5dcfd2b120fde9ff8467858ac6ad13669" => :high_sierra
    sha256 "848a883cf4c2be39562455860970305df4cffc691285cbd5e48f9ddd92a08732" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = "1.0.5"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = buildpath/"out/darwin_amd64/release"
    srcpath.install buildpath.children

    cd srcpath do
        system "make", "istioctl"
        prefix.install_metafiles
        bin.install outpath/"istioctl"
    end

  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
