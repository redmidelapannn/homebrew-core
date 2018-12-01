class KubernetesHelmAT210 < Formula
  desc "The Kubernetes package manager (v2.10)"
  homepage "https://helm.sh/"

  # Use git rather than tarball because the build tool
  # updates the SemVer and revision information
  url "https://github.com/helm/helm.git",
      :tag      => "v2.10.0",
      :revision => "9ad53aac42165a5fadc6c87be0dea6b115f93090"

  bottle do
    cellar :any_skip_relocation
    sha256 "38d7d296439da3a162822130893eefa7433bcf03130c4aeffc0c37cd45d2c65e" => :mojave
    sha256 "69dae07f11f69ac0ec50b2857a90ae435e453df2aec59b373e376b0905e15d4b" => :high_sierra
    sha256 "75b58fbda2ac718e63b6c03e2769e5ba1a2280aa0787a8e63916fc968066d6b2" => :sierra
  end

  keg_only :versioned_formula

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"

      bin.install "bin/helm"
      bin.install "bin/tiller"
      man1.install Dir["docs/man/man1/*"]

      output = Utils.popen_read("SHELL=bash #{bin}/helm completion bash")
      (bash_completion/"helm").write output

      output = Utils.popen_read("SHELL=zsh #{bin}/helm completion zsh")
      (zsh_completion/"_helm").write output

      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
