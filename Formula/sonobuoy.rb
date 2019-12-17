class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.17.0.tar.gz"
  sha256 "823dddb03b11ed7063a289435e2f10a002f36f22ea4c97a8d228ad9c798b54ae"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9a98640cf7f3c27810a3ad0b383c94eb341c46d145c53f8688fa6a8783fb5032" => :catalina
    sha256 "60278d8a7d21b8af74dfc78ea33ebac71e4da364f2b0f82c427ed651cad1c4bd" => :mojave
    sha256 "3b046ea86f477cd78af63957412b73220173df4c17d4548950787010e11cb45b" => :high_sierra
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
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
    end
    output = shell_output("#{bin}/sonobuoy 2>&1")
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance", output
    assert_match version.to_s, shell_output("#{bin}/sonobuoy version 2>&1")

    output = shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "name: sonobuoy", output

    output = shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
    assert_match "all tests", output
  end
end
