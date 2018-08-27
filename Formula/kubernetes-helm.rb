class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.10.0",
      :revision => "9ad53aac42165a5fadc6c87be0dea6b115f93090"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "85bf775733a4dfa3ac890d860320a95817cd2a36b5421a41c371b169977c7579" => :high_sierra
    sha256 "3869c85eee8a83bc3736abeb2196fedabed54cf7d15ca17c2fe9897fb97fd770" => :sierra
    sha256 "64c1cc09b818678a336120aa6490739f7d2425c4e5fae6567720b8e1e8c6d541" => :el_capitan
  end

  depends_on "mercurial" => :build
  depends_on "go" => :build
  depends_on "gox" => :build
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
      system "make", "bootstrap"
      system "make", "build"

      bin.install "bin/helm"
      bin.install "bin/tiller"
      man1.install Dir["docs/man/man1/*"]
      bash_completion.install "scripts/completions.bash" => "helm"
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
