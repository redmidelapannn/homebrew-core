class Rio < Formula
  desc "Kubernetes based MicroPaaS"
  homepage "https://rio.io"
  url "https://github.com/rancher/rio.git",
    :using    => :git,
    :tag      => "v0.1.1",
    :revision => "271d91966f46b9dc3b7113af43c64cac61576831"

  bottle do
    cellar :any_skip_relocation
    sha256 "d77fa4a4805e2b218faf064366f8fec5ae05b7fed5841468fe0f963bbf18a8dc" => :mojave
    sha256 "1d78fbd5a45b1ee6d3acdec36758622e052a2cabfebafd453914b1b9c70f1434" => :high_sierra
    sha256 "cd831e36e836621f6e60589566c55de101cdb98bc4aaef87f6796527f3c87f1d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/rancher/rio"
    dir.install buildpath.children
    cd dir

    system "scripts/build"
    bin.install "bin/rio"
  end

  test do
    run_output = shell_output("#{bin}/rio 2>&1")
    assert_match "rio - Containers made simple, as they should be", run_output

    version_output = shell_output("#{bin}/rio --version 2>&1")
    assert_match "rio version v#{version}", version_output

    run_output = shell_output("env KUBECONFIG=#{testpath}/non-existing-kubecfg #{bin}/rio install 2>&1", 1)
    assert_match "Get http://localhost:8080/api/v1/nodes: dial tcp [::1]:8080: connect: connection refuse", run_output
  end
end
