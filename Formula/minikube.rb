class Minikube < Formula
  desc "Tool that provisions and manages local single-node Kubernetes clusters"
  homepage "https://github.com/kubernetes/minikube"
  url "https://storage.googleapis.com/minikube/releases/v0.3.0/minikube-darwin-amd64"
  version "0.3.0"
  sha256 "cada05315d6643a3d8813b75c36b703773df739f32a576b25b8572a51ca90ee6"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfa11236b9bf1f116102e75d485f3267289d8c609ec8a04fbd6dbb739ef87a71" => :el_capitan
    sha256 "c7755173e1a9cb1f4ec36e8bf1c8595542dc9ef49985d6806c1cfa8800624431" => :yosemite
    sha256 "ebb870834ed8b051acaf2a63f865788dd09867e6ca424a15ffa06e9aa14674f8" => :mavericks
  end

  def install
    mv "minikube-darwin-amd64", "minikube"
    bin.install "minikube"
  end

  test do
    assert_match /^minikube version: v0.3.0/, shell_output("#{bin}/minikube version 2>&1", 0)
  end
end
