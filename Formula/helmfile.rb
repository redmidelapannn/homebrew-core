class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.64.2.tar.gz"
  sha256 "3a83237d919882bc59460076b2592151e67e11e86858d10d7e2d0db0ae037d96"

  bottle do
    cellar :any_skip_relocation
    sha256 "03e3cd0db7c310150d58a122c24e3b3d06edd5af0f4c22a0a1a81cacf25f1403" => :mojave
    sha256 "b38ed51d3fdfee3b8e3e6bc98e28281a286089e51b24360b0bad514c37e423e9" => :high_sierra
    sha256 "40c02dd73c20365664f2f30fa89b0b42825444c913cb2fffef5a1e4cded852fc" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/roboll/helmfile").install buildpath.children
    cd "src/github.com/roboll/helmfile" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"helmfile"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    system "#{bin}/helmfile -f helmfile.yaml repos"
    output = "helmfile version"
    assert_match output, shell_output("#{bin}/helmfile -v")
  end
end
