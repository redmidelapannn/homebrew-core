class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30725849b190fb9347648bded852bfdf46b64410854f6d0e2e7ebd7bb360eee7" => :high_sierra
    sha256 "fc1d45baf4b7ddf9e01d9c5dd12fc7a49e7abd69dc0a0e4f5274219e7fbc6ac0" => :sierra
    sha256 "9fe423e9dba2ab051183edabc99e9aa89fa8a275a625dfe1445816f7039d8de6" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-beta.1.tar.gz"
    sha256 "36964dec70ded30957d2d22d7f28978e034fe4a6b5047d0c8abf5992210c5623"
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
