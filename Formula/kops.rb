class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.9.1.tar.gz"
  sha256 "f725a2b2e9b94e24aaa965981f5126bcc65089197352efbd64c6dfa48f28e7d8"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "469c7ca40dbb5ba9f744f99dd3bafe84c6cd7e95d62689415f19b3ac540eaac3" => :high_sierra
    sha256 "3f374184b0e494c54821bf5df261d62b813111ca0413062e421cea32ec6b090e" => :sierra
    sha256 "0a2c9c03f1aa32ef7460fc652f6fc238f5e51e04fc60a837ef198b8530c01d16" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.10.0-alpha.1.tar.gz"
    sha256 "a8e3283361210e5be74746b58609ab88939553ea9c96095eca77088369b0c380"
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
