class KubernetesCliAT13 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.10.tar.gz"
  sha256 "7167e8c8e68d34596018103b55724f01d9b5e1f715c816c347a967cb438d6d18"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1efde95bfd4699aee66c724a46bd0b80dd097175702291507f9464fdc2c90b2" => :sierra
    sha256 "7c51a101e69a8c59ac81bdcd211cd3aa36af3e86ffdc4d9b33119412174a0b81" => :el_capitan
    sha256 "82696342c98b468be56de1de2e1437e23e396b2e8997e0b359d015cffa695799" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    if build.stable?
      system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"
    else
      # avoids needing to vendor github.com/jteeuwen/go-bindata
      rm "./test/e2e/framework/gobindata_util.go"

      ENV.deparallelize { system "make", "generated_files" }
      system "make", "kubectl", "GOFLAGS=-v"
    end
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
