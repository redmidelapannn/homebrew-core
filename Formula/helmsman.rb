class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.12.1",
    :revision => "445aa01d5cb1fbf3a3625ea04041fe0c5ff8655f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff7ab3c1f8deb1e1bc17f222db0e5543b14a4014211e54ed18789fb815c530e4" => :catalina
    sha256 "d5b8b4e2e2185493b8bc238f46cca2ced036b33ab38c3a4d840e6a042427da95" => :mojave
    sha256 "8bdfba9388a9328efdcbf9ba7ae0dafd622d7c14b098123b5fe7e06cd34a8046" => :high_sierra
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
