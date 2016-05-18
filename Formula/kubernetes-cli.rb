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
    sha256 "2520428f7937961167653647ad17934563aa878a1e9c6673506283ffce2585d6" => :el_capitan
    sha256 "f79c54d08bda3bdc1698e79e900fda6a6b3243f0c60f408240b1bf0ed68fc51a" => :yosemite
    sha256 "0736191123ce1c2896ea7b9ab1624b0926b036183a00b7733056ba2cad801607" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.4.tar.gz"
    sha256 "3cff9661b94c138149721e8f57411e89690afef97bcdb515092ca3acf8705900"
    version "1.3.0-alpha.4"
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
