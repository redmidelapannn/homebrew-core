class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.0.tar.gz"
  sha256 "77fbc5db607daa723e7b6576644d25e98924439954523808cf7ad2c992566398"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "dc11fa04c0c9d406e63e1542d88ac9ae32e3783d849ffd8aed242e459b4fc039" => :el_capitan
    sha256 "1061dd9c2cbd8b1af985e7aa9d6c8d5ee83546f0b8fd55558f4612abef0dc904" => :yosemite
    sha256 "a4bf43fedf3e5dc22133fe48ffe925d562a65ef2c9f57b72b12f47228685c0ca" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.4.0-alpha.0.tar.gz"
    sha256 "7530fabf418fccf7bef08281efa9a51d86921726c8efac4f0e63ba1e87d83482"
    version "1.4.0-alpha.0"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    (bash_completion/"kubectl").write "source <(kubectl completion bash)"
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
