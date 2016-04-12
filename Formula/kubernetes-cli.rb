class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.2.tar.gz"
    sha256 "28337012d145a540e840a1da0d0271ca53a6e279c790ccc409a1b82e2f675b54"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6ce750f364201fe3a59937b728aca62238b54540218cfe89240ca321c260672a" => :el_capitan
    sha256 "adc9dd77d5653901045f270f876568495ad2ade002fa62ec6f5d2b112c7169b2" => :yosemite
    sha256 "c9274291441192764aeb85bf364b4decd5b11ce5fb195bffacac85aff5ea5114" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.2.tar.gz"
    sha256 "a0d865e294a65cce54ab0ed3e5d04c574db4fca361e155f1e5f9f773ad699f5b"
    version "1.3.0-alpha.2"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    bash_completion.install "contrib/completions/bash/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
