class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.4.tar.gz"
    sha256 "20a3984f9c044f1a1da3088166b181f3c10380d3efd4bf3fbc64678fef279ced"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d95b32afd45ca3c6cc12364b0f329f35857811effc89fc08fd9fe2ddd4c3c7ba" => :el_capitan
    sha256 "678dd66dff67663ae0b85dfe21b0c2a3957a294f525941ebc1422443416732ef" => :yosemite
    sha256 "998cce2eb726cb058329e2f95d1473fcb2ed7dcb7dc20d001d83ae620fb664e3" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.5.tar.gz"
    sha256 "cec0d35366c6587c12b8a052dbbebd258c825c4cd47e9e84c2b3b2b2246a16b1"
    version "1.3.0-alpha.5"
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
