class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v1.1.0",
      :revision => "c0dd0a2ff00f62664f73b6e7a8eeff9bfd9c5e64"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "44d2a28cc47aeb1a20d90bc542f8cd807b392c6ae40853f0e83cd9be34c6c113" => :catalina
    sha256 "1d84f66a12c184eb86f74667f4349b9ac0b57f1ae07090006d00eaf5e27269d4" => :mojave
    sha256 "2d0dcaf86f00bbb5db79f4e11243cf4ece312bafcd061597e1b02d0a4b6f033f" => :high_sierra
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
