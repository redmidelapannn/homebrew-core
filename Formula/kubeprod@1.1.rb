class KubeprodAT11 < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.1.2.tar.gz"
  sha256 "1145150acf696830c780fb4d9a9f05c5eb34a792e81c0db840f0728e6be920ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "22441a1078b3a5e5d94e5510b4188f3b5af66911d3a22f08c8f7c6b69eb9f003" => :mojave
    sha256 "c83a1956c1bc9fa5e6e2594f15480b697a4dcb13cc94e7b3772c8f3c9b6589a7" => :high_sierra
    sha256 "a2f12b8189b8bd0c495fbde7290399787f37a5b835b55644466407655cc1974a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/github.com/bitnami/kube-prod-runtime"
    dir.install buildpath.children

    cd dir do
      system "make", "-C", "kubeprod", "release", "VERSION=v#{version}"
      bin.install "kubeprod/_dist/darwin-amd64/bkpr-v#{version}/kubeprod"
    end
  end

  test do
    version_output = shell_output("#{bin}/kubeprod version")
    assert_match "Installer version: v#{version}", version_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    authz_domain = "castle-black.com"
    project = "white-walkers"
    oauth_client_id = "jon-snow"
    oauth_client_secret = "king-of-the-north"
    contact_email = "jon@castle-black.com"

    ENV["KUBECONFIG"] = testpath/"kube-config"
    system "#{bin}/kubeprod", "install", "gke",
                              "--authz-domain", authz_domain,
                              "--project", project,
                              "--oauth-client-id", oauth_client_id,
                              "--oauth-client-secret", oauth_client_secret,
                              "--email", contact_email,
                              "--only-generate"

    json = File.read("kubeprod-autogen.json")
    assert_match "\"authz_domain\": \"#{authz_domain}\"", json
    assert_match "\"client_id\": \"#{oauth_client_id}\"", json
    assert_match "\"client_secret\": \"#{oauth_client_secret}\"", json
    assert_match "\"contactEmail\": \"#{contact_email}\"", json

    jsonnet = File.read("kubeprod-manifest.jsonnet")
    assert_match "https://releases.kubeprod.io/files/v#{version}/manifests/platforms/gke.jsonnet", jsonnet
  end
end
