class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1712396f470b26cbbbdc025e498fffe07fa55266ff0f33f41f2bd8ce0fd70683" => :high_sierra
    sha256 "0c474e2a9ddecd6f8a6127d2bce8c039b175b7fad0a535ac6b6bd2c6f37a4571" => :sierra
    sha256 "258c942caa99ec004cb4951a3907a72fa9e869fd5b0749479008a68e89b3c97a" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-alpha.1.tar.gz"
    sha256 "d174c32c4a059a9d267baa73bee31b7e291f65ea8a37b30fb3e5919cfa4c8f10"
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
