class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.12.1",
    :revision => "445aa01d5cb1fbf3a3625ea04041fe0c5ff8655f"

  bottle do
    cellar :any_skip_relocation
    sha256 "383aba385f7556e111769fed65496612d25459c215cc3312452837fe74866296" => :catalina
    sha256 "911785a3e8becbe22d506b2eebaead34613be1a09f3ce8de6a9323aedcf06b4b" => :mojave
    sha256 "c36936bb80f68f1e8807486a71b895b94ab17e80b781199b33cb062de5abb026" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Praqma/helmsman"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"helmsman"
      prefix.install_metafiles
      pkgshare.install "example.yaml"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
