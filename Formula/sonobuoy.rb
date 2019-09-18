class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.15.4.tar.gz"
  sha256 "2209477533c600e02c94d367feeb8bdb95e4c83251d072e1e471766552d6b648"

  bottle do
    cellar :any_skip_relocation
    sha256 "086009ceb2102a42d97e74a6d8b29143db71cc29daabc7096abb7d4692ccbd67" => :mojave
    sha256 "8d507fc16eb680ea8b8b98ef6db048ad197cb496b31e199445d59bd0b32dda62" => :high_sierra
    sha256 "a7f38f2d3a23d71cc0ce21d9e81fbae6b99b3646a1a7db9894ab9889d87d8607" => :sierra
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/heptio/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/sonobuoy").install buildpath.children

    cd "src/github.com/heptio/sonobuoy" do
      system "go", "build", "-o", bin/"sonobuoy", "-installsuffix", "static",
                   "-ldflags",
                   "-s -w -X github.com/heptio/sonobuoy/pkg/buildinfo.Version=#{version}",
                   "./"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/sonobuoy 2>&1")
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance", output
    assert_match version.to_s, shell_output("#{bin}/sonobuoy version 2>&1")
    output = shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.12 2>&1")
    assert_match "name: heptio-sonobuoy", output
    output = shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
    assert_match "all tests", output
  end
end
