class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "28197a0dd8a20432d67748b6859d0d17d6f6deb06ab6e4f6132a53e9b4fdfe3c" => :high_sierra
    sha256 "bf77e3bdfb862a70ea62d4cbf83efd6357e345da3ccedf9dce04fb0f2461b687" => :sierra
    sha256 "888062fb893e2ae4ba3c2642f5608f563bcae247b6f42772d3f1415d519af8a9" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-alpha.2.tar.gz"
    sha256 "7daf04bd4f23cd54b1adea758dcbaf54214adf661219a2cf70d4b0b2d11be003"
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
