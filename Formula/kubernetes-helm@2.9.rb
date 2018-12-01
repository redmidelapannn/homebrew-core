class KubernetesHelmAT29 < Formula
  desc "The Kubernetes package manager (v2.9)"
  homepage "https://helm.sh/"

  # Use git rather than tarball because the build tool
  # updates the SemVer and revision information
  url "https://github.com/helm/helm.git",
      :tag      => "v2.9.1",
      :revision => "20adb27c7c5868466912eebdf6664e7390ebe710"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed80e84ca83724ee33ac47f68f7ff44ae7afd1a64ec86fb0740332e0b6504dd8" => :mojave
    sha256 "ca914a94588e9e573cfc9db3f89809c155a729186530d8bc863deb7bb3f518df" => :high_sierra
    sha256 "f7ca8de0a2c3e2bb4570c8af50d2ac275f14d206061ee9d6956a734441cd7a4e" => :sierra
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
