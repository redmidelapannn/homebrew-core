class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.1",
      :revision => "82450d03cb057bab0950214ef122b67c83fb11df"
  revision 1
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    sha256 "69ec4b4aa3f207591a7d149cb271ffdc318009e9d4eb1d139dfdc7261ba69cad" => :sierra
    sha256 "60274fe99891eba36df44ffe6078dd62195594316ce4cb44f67bf442e5422efb" => :el_capitan
    sha256 "20e8a39287142bc8e42f51962579e56a3ccad90449b2d1348e3b9d8138a4bb0a" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.5.2-beta.0",
        :revision => "5f332aab13e58173f85fd204a2c77731f7a2573f"
    version "1.5.2-beta.0"
  end

  depends_on "go" => :build

  def install
    # Clean git tree
    system "git", "clean", "-xfd"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }

    # Make binary
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
