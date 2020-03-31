class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.0",
      :revision => "ee820f55a93215e460a8ef2201b94a8f741c8e8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9e299dc6a195a7905f11815ab7d68380334255233f7bbccf82f0ef0528bf35" => :catalina
    sha256 "c2a6895b1cbb164f099b29e9b3ac8b61989164dfbbb41e2d94103946a6f88a15" => :mojave
    sha256 "b43eef82b77514b89fc2e7781610b58b194eeec3dff7cd530a8330b40943dcd9" => :high_sierra
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
