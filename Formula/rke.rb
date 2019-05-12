class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.3-rc2",
      :revision => "ca91448f0d45b4de94675004a2b30bfc84f157be"

  bottle do
    cellar :any_skip_relocation
    sha256 "029d033f86f215800c344cd37061e4f8e4479ff5c1d81112ecf4c54c85bee1b5" => :mojave
    sha256 "7f1dd8df336cea7a61d34a2ad740e095bc534aee1669e76ee1dbd310bdb9b4f3" => :high_sierra
    sha256 "161f2bb017f71d66c71e0aa4732e1f8181791b4341d0889ac5cea48b9f730ed2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
