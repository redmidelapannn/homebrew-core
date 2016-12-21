class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.1",
      :revision => "82450d03cb057bab0950214ef122b67c83fb11df"
  revision 1
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    sha256 "6b4c4b779a0aaec8746df84620ce1e77bb9d3e032129660981511b3227d3bbde" => :sierra
    sha256 "211c81aa8c9ec4624874cfaaa0239d9b5ca4680e6b5818c28ba3b39469272600" => :el_capitan
    sha256 "047a18cca177b360898586c9dcac0f7a3d4ec0ce79e614b4baf7110fa231f0ee" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.2-beta.0.tar.gz"
    sha256 "03cba084d096c5898e1c72f359149dda74144bec4a8aeb672270cf1a2f976a0d"
    version "1.5.2-beta.0"
  end

  depends_on "go" => :build

  def install
    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
