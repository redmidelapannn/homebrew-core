class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.2",
      :revision => "08e099554f3c31f6e6f07b448ab3ed78d0520507"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dab39044b4c833b40e53527904d5d44bfbce5bb1746a0e178dd8fcff6a8d0228" => :sierra
    sha256 "7a737f0e4cb13ebae398c85ce42849b1b8d2d985f182a55e9e9c6ba69668b067" => :el_capitan
    sha256 "f0fdff8c9ddbd9408f7a8cad75b97bad24bdf4de8a1bcb5fb216bab8b3a0b9c1" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.6.0-alpha.1",
        :revision => "424a0e9e827a39c714ee03e1891c43635adabcdc"
    version "1.6.0-alpha.1"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OSX Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/darwin/#{arch}/kubectl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
