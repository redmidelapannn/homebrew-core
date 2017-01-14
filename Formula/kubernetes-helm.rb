class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.1.3",
      :revision => "5cbc48fb305ca4bf68c26eb8d2a7eb363227e973"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    rebuild 1
    sha256 "9060161e0544a359d88ca0d9256f408ac346b7ff8d9812f829905bb9dc9faf08" => :sierra
    sha256 "fe67b265cac55b6271765618505b3f86cf3d5c27aa3959480944d1ddfa271557" => :el_capitan
    sha256 "729bb01131d2f548b60a68501af2f5d0f449a3de614739aa177634eec67aff41" => :yosemite
  end

  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "bin/helm"

      # Install bash completion
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
