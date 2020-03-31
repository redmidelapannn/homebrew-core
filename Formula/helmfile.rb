class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.106.3.tar.gz"
  sha256 "5c76c49b07ba6735d9b0e138d69487e41915e61e231b4b825c5362e05a950461"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd839d4f056b8e88a34ae90618441a8d1d32333328fb953107526fa118b2f2be" => :catalina
    sha256 "7f4f7e359b3d30c2ba4195719a554b305908afef4c66ae039bc7e24d74ad6922" => :mojave
    sha256 "6ae7980b62f038bae944199d769057e13f45f35783e8dff6611b8483a2756172" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
