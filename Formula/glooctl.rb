class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.13.7",
      :revision => "6f52c7c8afa0249c7887c0ed4376feb922db53aa"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a68e6c2902f2b0324f5fb9f958f5fab9e805d801bf733e94ff93ccaf25f71ba9" => :mojave
    sha256 "daab4eca22229a25596fdf3b17e3f3a96ea3457a4269521d58fadb7621f8fa80" => :high_sierra
    sha256 "db0a7083dc459dc63b15e19856ea78f3d9c19a0080940eda985b0e181014e5c3" => :sierra
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

    version_output = shell_output("#{bin}/glooctl --version 2>&1")
    assert_match "glooctl community edition version #{version}", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
