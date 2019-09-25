class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.2.tar.gz"
  sha256 "059fe356c02b7e8e3bc3cca299ce521d1ca86f59965e98ca30c66a16e71c1494"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f695de6d9429a91d6ee9f45049e595682130cc086f05c62c0d24d94601b83aea" => :mojave
    sha256 "08c7943f5a71a8cfb94560b9f33a561112088fa1858592e36b2c68571b1d3bde" => :high_sierra
    sha256 "c0e5d93f4a458e6e45923b9420b5cf643509c529f3d0058fb6778bf291320655" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

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
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
