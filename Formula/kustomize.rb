class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v3.2.0",
      :revision => "a3103f1e62ddb5b696daa3fd359bb6f2e8333b49"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a56fcd07448dcc8e550cd5a03da4ab4b66885e3596101c78e11b327a23e4efe2" => :mojave
    sha256 "1c8c0889d03a899f66c6478e6fde871bb29d2bfdf610fbf4ce95a1f83b2be627" => :high_sierra
    sha256 "f1ec26da6d653f15e61d27d6a1c8007da6b893c7b18b3f79daf565527eddc8d7" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip

    dir = buildpath/"src/kubernetes-sigs/kustomize"
    dir.install buildpath.children
    dir.cd do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.kustomizeVersion=#{version}
        -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/v3/pkg/commands/misc.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize", "cmd/kustomize/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kustomize version")

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
