class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.35.1.tar.gz"
  sha256 "11a61f560a2f49411ea6908272ee7ff43e02698be4c258542b6bec1f4c3c24c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e604637ccca752571dd8b77e2414f14193923aaf2f62016e4177147794907c9d" => :mojave
    sha256 "de1851348519555ce56d5e292b3b60e0a17d1d95c748664a620dc1c0366689b0" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    srcpath = buildpath/"src/github.com/replicatedhq/ship"
    srcpath.install buildpath.children
    srcpath.cd do
      system "make", "VERSION=#{version}", "build-minimal"
      bin.install "bin/ship"
    end
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/ship version"))
    assert_match(/Usage:/, shell_output("#{bin}/ship --help"))

    test_chart = "https://github.com/replicatedhq/test-charts/tree/master/plain-k8s"
    system bin/"ship", "init", "--headless", test_chart
  end
end
