class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f2d0e8dbf23bc2416e30f5eecdba782e77aa9ebf90eb6135e74a9b5b417eeb13" => :high_sierra
    sha256 "de4fb4a412e429e315f44ce14aae0ca50b52e072bc77385b68c43535d6f0a37d" => :sierra
    sha256 "e9a0bbe083bb56e4f752d0c16e0a276197bc656deb6b281ebe9b353c7e765813" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-alpha.3.tar.gz"
    sha256 "4fc91f9d535af36db5032913e27091f1ddd16802c1626721ff26859461662559"
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
