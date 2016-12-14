class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.5.0.tar.gz"
  sha256 "0992af9e13bf756f0fb2abf08cd258631d08103cf833bb62936f09d2d5c60eb3"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bc16450f4ba5cd5ad3e45ae72d1c062ab0a3834c1e807b754711625610ad4903" => :sierra
    sha256 "549f5c0d408bed2189cb35bada59f23b81ee069d56772c3b2c51ca0a65ea5d56" => :el_capitan
    sha256 "8ef08d21061682e094f36afd67917a9d795e08919a1ffb992eb7115db34e7e95" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.2-beta.0.tar.gz"
    sha256 "03cba084d096c5898e1c72f359149dda74144bec4a8aeb672270cf1a2f976a0d"
    version "1.5.2-beta.0"
  end

  depends_on "go" => :build

  def install
    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl"

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
