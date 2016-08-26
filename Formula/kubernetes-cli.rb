class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.5.tar.gz"
  sha256 "f7c1dca76fab3580a9e47eb0617b5747d134fb432ee3c0a93623bd85d7aec1d1"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c75d40ad346459aa20760576c6adbc27f9e7310485e0730e55a2d26b8ffbf313" => :el_capitan
    sha256 "1dff636d2addc7c57f16ea58abc453f002b0a74034692a472fc4144bfb8f11cf" => :yosemite
    sha256 "ad62f3b37fa9940b46849146d008ef7bb0f0ffefa5966a768c1d25f1995f9957" => :mavericks
  end

  devel do
    # building from the tag lets it pick up the correct version info
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.4.0-alpha.3",
        :revision => "b44b716965db2d54c8c7dfcdbcb1d54792ab8559"
    version "1.4.0-alpha.3"
  end

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
