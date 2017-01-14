class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.2",
      :revision => "08e099554f3c31f6e6f07b448ab3ed78d0520507"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    rebuild 1
    sha256 "8088e1b89c1dfd1dcc582b45aa561f8a1fdb95fb49b2d729f368a59c6cfe7ea3" => :sierra
    sha256 "e87d1cccf495fbe72b3e966c4c1e36573790ff9cc9ccf5a2eda6cf4c02a7c883" => :el_capitan
    sha256 "abafda643897ad2a93d2ff2ef14827ef8f75ce623ad836319d76a193ed9189d8" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.5.3-beta.0",
        :revision => "b5f9d56cab78ccaad2b726223ba8be5802026f0b"
    version "1.5.3-beta.0"
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
