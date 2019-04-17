class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v2.13.1",
      :revision => "618447cbf203d147601b4b9bd7f8c37a5d39fbb4"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "14afd9ab84a4e5e037e4637950ec7f575a7ee042818b32d790112844c66d5e27" => :mojave
    sha256 "f95f27654c83572da82bc3116974592fd6ff90bfbf4402a36fba6c86cd19cba5" => :high_sierra
    sha256 "9e30c9436b86927d1320145bc2200114525e0f1b2673ca00396d042312135807" => :sierra
  end

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
