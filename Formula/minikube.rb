class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.9.2",
      :revision => "93af9c1e43cab9618e301bc9fa720c63d5efa393"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d51a63af17f1abcb3238955aec8358c4699ee693fb333f1d447a5cef6719fedf" => :catalina
    sha256 "2357b42d2309cdbabb8dd94db1c748977460be6e3b1c25eac5dcf7d563317ef3" => :mojave
    sha256 "9e03f12e08a28a90db2a51ae7f4f9f3baa494459c9f741c78a9b6d9d828fb466" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.popen_read("#{bin}/minikube completion bash")
    (bash_completion/"minikube").write output

    output = Utils.popen_read("#{bin}/minikube completion zsh")
    (zsh_completion/"_minikube").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
