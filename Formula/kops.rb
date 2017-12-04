class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "431646483c8bd4ceea40066228827b480b0d91c381ddb719d8b0f4e8736fb102" => :high_sierra
    sha256 "64a132bb4b2f30e183c5e2b104965d64a435409f08bb3c1decaa1502b93f2662" => :sierra
    sha256 "4c07bfa3642b284a6ee8e45b821f072bec9862d1a280264a5d473c5423de3834" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.8.0.tar.gz"
    sha256 "dfab4c304247723d02cdabc83840ff0fbfd8ae4238d248839b06cd62f84400d7"
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
