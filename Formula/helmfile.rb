class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.60.1.tar.gz"
  sha256 "348c5af8422110c691d397e0f980aa73c051a528f3e1440d7143048ba471ade2"
  head "https://github.com/roboll/helmfile.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3490753031a64b8be1d98361815a7fe2d878473945192b48456689b90e9a2256" => :mojave
    sha256 "7d0d449a81b252c6f1e0be3ca52088cf30b1c25ecdf0f1400a2e363325ee0e4a" => :high_sierra
    sha256 "d0c08425d8cb81bf692d9af1561ca370b9fe3822613925cac17a97f8e7d86e06" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    (buildpath/"src/github.com/roboll/helmfile").install buildpath.children
    cd "src/github.com/roboll/helmfile" do
      system "go", "build", "-ldflags", "-X main.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
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
    output = ""
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos")
  end
end
