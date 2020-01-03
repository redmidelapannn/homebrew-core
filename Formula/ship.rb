class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.52.0.tar.gz"
  sha256 "37622f1671947b038b7061341bfadbaa44e16bb9c59748cce57d2a68fb8f0d54"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "91990420068cebaa881b2168965ca86475cd0cbd2a74a3427092c597a7b0ad07" => :catalina
    sha256 "6d7c6f33739e77350c058d88e15558e506a9efad48f6e94ec48120021fed9257" => :mojave
    sha256 "36f4f93f4723e72f2549ed0bedb46a77ad02feda62dd0baa1c61a72c4b020751" => :high_sierra
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
