class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.1.2",
      :revision => "58e545f47002e36ca71ac5d1f7a987b56e1937b3"
  head "https://github.com/kubernetes/helm.git"

  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/k8s.io/helm").install contents

    ENV["GOPATH"] = gopath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", gopath/"bin"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"

    cd gopath/"src/k8s.io/helm" do
      # Ensure a clean git tree for version output
      system "git", "reset", "--hard"
      system "git", "clean", "-xfd"

      # Bootstap build
      system "make", "bootstrap"

      # Build/install binary
      system "make", "build"
      bin.install "bin/helm"

      bash_completion.install "scripts/completions.bash" => "helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
