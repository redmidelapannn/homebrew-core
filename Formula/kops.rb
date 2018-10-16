class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.10.0.tar.gz"
  sha256 "08f6ddf64e9003f12df8a33afe077418994aff40ab0b655b2fe162c63cfc7190"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "372b45d2a3c9bb15be1c3a1df78cf1515ebd8a2822faa990f5b48d5bf3a99d1e" => :mojave
    sha256 "2a854b76f8c68da48e014245c0f7267d508e9901625da9dac031b5c131e9ff0d" => :high_sierra
    sha256 "db2d6633e1c1bd729fb46641fbc85399f46027f0b1632743fd60ac2d97d85c89" => :sierra
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.11.0-alpha.1.tar.gz"
    sha256 "7ec64e4fd72e7c43da15cac6b13eb99f7bd955254abb440f5f042863f6646bb9"
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
