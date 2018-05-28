class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.9.1.tar.gz"
  sha256 "f725a2b2e9b94e24aaa965981f5126bcc65089197352efbd64c6dfa48f28e7d8"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a4116f7b3251e353a8ad1184306706985f05d95dfdd1dd1c5afcd87180fb670" => :high_sierra
    sha256 "fc446d7afff675d80377198f3de22c493e82d76b64961bbd9581ae45d4e86478" => :sierra
    sha256 "7a5251b11e975fdd7b41a9782fc3aeb8ff2dd9ac76e72964d333f34fb68e6524" => :el_capitan
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
