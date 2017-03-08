class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.4",
      :revision => "7243c69eb523aa4377bce883e7c0dd76b84709a1"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0ec68058caf0501f4b33659867baa1ba1caa4334cc54ccd87a3ed91948dd2a6e" => :sierra
    sha256 "bc7121e97a660288f39322c67cd344908465dbfa64eaac7d7f186efcc4d92db1" => :el_capitan
    sha256 "7fdb818e251b2dbba2df50826340ce3f012ed72adf77e8ea3ec644ed02173489" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.6.0-beta.2",
        :revision => "8af9c3e53bc2c508d9948cb511372057339656f1"
    version "1.6.0-beta.2"
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

      # Install zsh completion
      output = Utils.popen_read("#{bin}/kubectl completion zsh")
      (zsh_completion/"kubectl").write output
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
