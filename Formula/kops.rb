class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.10.0.tar.gz"
  sha256 "08f6ddf64e9003f12df8a33afe077418994aff40ab0b655b2fe162c63cfc7190"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e792e5fc3f89ad5e2ee641395f8158eb6d566a3584d8e7a80f963f05a430a2f7" => :mojave
    sha256 "684fa1dd6dfcfa78cf5f10f889e8075c5b4e639cab335121a7932d3d01a8e9cf" => :high_sierra
    sha256 "7eee37e27086be3a2bd53dbe244e515ee9240d9d40dc8bb5ff03dca0179d3183" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
