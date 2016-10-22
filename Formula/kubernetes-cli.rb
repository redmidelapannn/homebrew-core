class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.4.tar.gz"
  sha256 "ab6304dbff6e49095d68459da748477ffba231893e1f1dae4e0d60ba2fdb725a"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "153004c64c59cebb19469eb2a7193e79e89590da0ed61acaf260574e0c29d7e5" => :sierra
    sha256 "d614bdd3e171d7d1b3bbe167fdee3b58d6484cbe5afa89efc58e161b7bc33429" => :el_capitan
    sha256 "869f690606138398aa4c4ec73ddb9a291a545a138e84035dc6ccdbcad338773a" => :yosemite
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
