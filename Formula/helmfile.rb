class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.109.0.tar.gz"
  sha256 "ab4a444fc305cfd1d2447eeb94cfee3c60f46815b4301db68d02703be12a2a8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7ea8b5f4a02ccedc1fda0556edb13b6dd8674c6d249d4b20a99d0ec2343eafe" => :catalina
    sha256 "7bd00f228077d4e3c68ffa491d37360768043a4310fcb94164da050f876e7fd8" => :mojave
    sha256 "2814debf12bdf98cfdc445691391f23978b818875e3eb7c864123254b0f8cbc9" => :high_sierra
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
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: roboll/vault-secret-manager     # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
