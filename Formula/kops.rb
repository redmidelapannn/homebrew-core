class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4c56943c794c74f6c83720dbc4350f72623407b74cdd3d1b696276f9ab46bb91" => :high_sierra
    sha256 "7d75d2ebd21803a0a6cb5feb6014d18f6e7ff84008882e9f0c831f5b7bc89496" => :sierra
    sha256 "8dfc96c3d965c8fcc59fe02116386c608b01e526839575c9127fcd9fd241f51f" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.8.0-beta.2.tar.gz"
    sha256 "f82a3fd9672a839b3991b7109a0d2fc5e73491e104c5afcb0168e65d20cffcd9"
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
