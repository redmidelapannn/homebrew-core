class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190730145854.tar.gz"
  sha256 "d5cdf69f2ee0bc4840e58da8f035a51e7a62707eb57286f4a1f51c86bff92b73"

  bottle do
    cellar :any_skip_relocation
    sha256 "70d219a587820a2df4ae1e7d216c63a3b01c721a501e5837685ef1bf8fec0700" => :mojave
    sha256 "91d5fbf88aa850134c765c634bc7975094263dd0118f1b95c5d9b97912a7eb87" => :high_sierra
    sha256 "d295006ff6cbe039c1de132fb27403bb7fc09f8143e78fdb7e930fec49c5b6c5" => :sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/convox/rack").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }
    cd buildpath/"src/github.com/convox/rack" do
      system buildpath/"bin/packr"
    end

    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
