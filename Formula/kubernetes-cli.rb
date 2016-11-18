class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.6.tar.gz"
  sha256 "dcbbf24ca664f55e40d539a167143f2e0ea0f3ff40e7df6e25887ca10bb2e185"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a5788dfb105e32f0a7803abb1faa9ff11c4a96bb57d2d9e902b7901fa07a613" => :sierra
    sha256 "0d22e9be5c523871cd45fa1eed4bc77f77d7f04ec78722004594f2d37bd9c3f6" => :el_capitan
    sha256 "b473cf7e549217cafefbff4061733fbd16a5ed8287be63b51f0b0eb2e88491bc" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-beta.1.tar.gz"
    sha256 "ab1f40ab7149a47adda74491ad784f07c2b8b08fb2a36742a99e6e6f3a6adcfb"
    version "1.5.0-beta.1"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
