class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.2.0",
    :revision => "63a52dc33f99416593758fb2384e150607254885"

  bottle do
    cellar :any_skip_relocation
    sha256 "c476da7cd074b1a293b5aadf36859310c37bf76067850015f983dfa4f81c36c8" => :catalina
    sha256 "aeef2d15731e7ea82c2129daa550294484285d363c257f436c0a8662e653790a" => :mojave
    sha256 "9c9ecfce2ed46ca2f61b5bd6c1d9d921b86499b6f803cc19354b609880816f2f" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      "-trimpath", "-o", bin/"helmsman", "cmd/helmsman/main.go"
    prefix.install_metafiles
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
