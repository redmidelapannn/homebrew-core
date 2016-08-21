class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.4.tar.gz"
  sha256 "19b2ebbc3976bb97883dc40aaf14ded7863d4098922e99a1dad873d5435fe21e"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e428be82efe75477c6d4360c5334bbf833e6db5d6664f9457d70583acb2538de" => :el_capitan
    sha256 "6ccd933cd567edcf705e1e67dd4f059fcb7e2d933919f0b95d9f58dcab26d923" => :yosemite
    sha256 "813bc7525bdefe9afff8e3e4df22484e5a764d51b982638c4a1e36e6433b9997" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.4.0-alpha.0.tar.gz"
    sha256 "7530fabf418fccf7bef08281efa9a51d86921726c8efac4f0e63ba1e87d83482"
    version "1.4.0-alpha.0"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"

    (bash_completion/"kubectl").write Utils.popen_read("#{bin}/kubectl completion bash")
    (zsh_completion/"_kubectl").write Utils.popen_read("#{bin}/kubectl completion zsh")
  end

  def caveats; <<-EOS.undent
    Add the following to ~/.zshrc to enable zsh completion:
      source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_kubectl
    EOS
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
