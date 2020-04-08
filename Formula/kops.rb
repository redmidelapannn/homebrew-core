class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.0.tar.gz"
  sha256 "0154395acb7d612a3f072e29db424d8c8065d77b324540a1517aab297d28b3ff"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1845257b8d0b660b05e13d0b6670393c2e2ede02cb845174b298e4754a842e6e" => :catalina
    sha256 "f72a895c3f3886f0434c7ea7e575639a7a1cb37739f5de9679a385e98b671696" => :mojave
    sha256 "93b33152ad877e5b7ff335420a2e5c26e3ffb1292180b95a3391607ed9cdbdc6" => :high_sierra
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
