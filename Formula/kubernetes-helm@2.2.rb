class KubernetesHelmAT22 < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.2.3",
      :revision => "1402a4d6ec9fb349e17b912e32fe259ca21181e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d2670e0090b548c2fc8c7fa509a8b04c5f6e6e168c36b2e272961b83ae2cd9a" => :sierra
    sha256 "b1881bff80f72907fb7cac15ef2cd7ebd9df0f7521fbf7e9f2d7508182d55141" => :el_capitan
    sha256 "6ca551c393193841fd347b5190c3fe7378c4a4d5fd7c1f4e5e8508c20108f959" => :yosemite
  end

  keg_only :versioned_formula

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
