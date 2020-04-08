class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.107.0.tar.gz"
  sha256 "921653bdf356ec2bbf0d83fe65cd562efffbda7fd1f29407ee489362f6ad8d9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8616d163582d8caa85e65d0b4fddadb7e6091300b5317c9fd8882c116613575a" => :catalina
    sha256 "38fdf9a7a941203df9090eac8aae90e0e3606c12a908a3e4bddbc0a75bd6a806" => :mojave
    sha256 "3a2c42eda6bd5b0a8a2b50f0fd7e4b712cdb7f574e35dbb020fb5884afe36f63" => :high_sierra
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
