class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.20.1",
      :revision => "102a3a56c1b2059c2177a2e1629d52d8dc5b0639"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9d74c52227575dd991b88e809b5972c611f32f9f7ac26b6d209f082c51e1b693" => :catalina
    sha256 "55f87a1de9c1bf843dac0e58cb752bbdc08c56077cc1b2c43fa16e63be643665" => :mojave
    sha256 "59365442a900e2c735781a96f168e97f53ecc2673cee29cc61ba3dd6d973df3f" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
