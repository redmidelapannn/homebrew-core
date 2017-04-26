class Minikube < Formula
  desc "Run Kubernetes locally"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube/releases/download/v0.17.1/minikube-darwin-amd64"
  version "v0.17.1"
  sha256 "b175c355d377a6ce2fefdd19201c865a7e628581261ac949fffb725af459c389"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa644c08e116e794b315a479a48b9c2d820b89799907a82a981af9832d006196" => :sierra
    sha256 "a879ab165907de5252abaf8871cf469e2fa8193f8438776e4f4df4ad722c4dc3" => :el_capitan
    sha256 "a879ab165907de5252abaf8871cf469e2fa8193f8438776e4f4df4ad722c4dc3" => :yosemite
  end

  def install
    mv "minikube-darwin-amd64", "minikube"
    bin.install "minikube"
  end

  test do
    system "minikube"
  end
end
