class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.9.1.tar.gz"
  sha256 "f725a2b2e9b94e24aaa965981f5126bcc65089197352efbd64c6dfa48f28e7d8"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2460cdd395abf7d2e5b229be111ecf282fb5d6d1d49a6003a77df018f04fbbae" => :high_sierra
    sha256 "d244309e00c8cb20abe10ccda2416b5245c3320b6363be7d68fbec1aaa36bf7e" => :sierra
    sha256 "aa2e0af1a998b27727e136d085d7b5321404ff48df3d871113a1a595b3e93875" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.10.0-beta.1.tar.gz"
    sha256 "8d3a61ada407c787b8b8052360d6921a70ddae8644f8b875efaa5ed4cc53bdc3"
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
