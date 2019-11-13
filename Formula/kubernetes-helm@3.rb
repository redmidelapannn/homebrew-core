class KubernetesHelmAT3 < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.0.0",
      :revision => "e29ce2a54e96cd02ccfce88bee4f58bb6e2a28b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bd78cf9758df6b11b911a69979798b74d01f7a9a23dd1d28e85fc3e895ef548" => :catalina
    sha256 "b82e6286768aeab30f7c2d00a1f7c2ddf58e74968328fcd925bea9035592f370" => :mojave
    sha256 "cb8ec19e1c6ac73396eba0acb0859894760796dcfd4e77364ebdff36fea2f7c4" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build"

      bin.install "bin/helm"
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
