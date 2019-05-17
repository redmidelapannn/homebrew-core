class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.12.1.tar.gz"
  sha256 "0ea72a28fedfc2ed6b2bcda4ad02d4fc9d4548c47b9011c4526da95f8b7a3d71"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e99a87f8a3dd5134151166837d7fb19469560b78e36d0cf0c23560793231ff06" => :mojave
    sha256 "e224831cdd58fe51b122ad0624569f36633bf9223f180ba74ced3ad8d1ffe728" => :high_sierra
    sha256 "30bb6bb26189686bd8ac3725cd5e30c72f3f9cc6fe53aa82b7f2b43fe30e97f8" => :sierra
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
