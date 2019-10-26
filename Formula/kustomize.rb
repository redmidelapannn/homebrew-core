class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "kustomize/v3.3.0",
      :revision => "7050c6a7b692fdba6e831e63c7b83920ab03ad76"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d82e5a9dab764694091161e9178a8877c80bc02ef29192e653175c012fd255ba" => :catalina
    sha256 "05e7e865595ebfc72353ec28cbb8b1ecb38b59da5351c61f982d966317e60950" => :mojave
    sha256 "c4a7f27c1e36efda98980f88d6735f273c3dbaaf750868887d85f6c303b78ce8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip

    dir = buildpath/"src/kubernetes-sigs/kustomize"
    dir.install buildpath.children
    cd dir/"kustomize" do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/kustomize/v3/provenance.version=#{version}
        -X sigs.k8s.io/kustomize/kustomize/v3/provenance.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/kustomize/v3/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patchesStrategicMerge:
      - patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match /type:\s+"?LoadBalancer"?/, output
  end
end
