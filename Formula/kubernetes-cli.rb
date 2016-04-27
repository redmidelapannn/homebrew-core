class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.3.tar.gz"
    sha256 "542db5eb9f635aae53dc4055c778101e1192f34d04549505bd2ada8dec0d837c"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e8255cad8e776fb7986f7e2e701ed163b8bfaaed66411666e2f7c1a9cdd501b9" => :el_capitan
    sha256 "95ed09d99f743f6c39f92329d8fcc2f3280c89628807c1e7cd115d2c86e858e2" => :yosemite
    sha256 "b9a52265e14afbf6cb7b2ddeaafbce926ddb0a4747e8d2212fe3c3bb07581398" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.3.tar.gz"
    sha256 "887bcb59fb517124b22ca683d1161aff571a86e42b48e89ba748629a4d259992"
    version "1.3.0-alpha.3"
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
