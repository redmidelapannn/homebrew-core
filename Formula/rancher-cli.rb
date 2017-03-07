class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.5.0.tar.gz"
  sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "64f0532f85959c5d3ac9b89dec50042d1f2f76f041401d681850582af9d13866" => :sierra
    sha256 "fc87596f48fc933d6e8e90fe881ec0c5d2633ec13e029c37fbf2baca61002185" => :el_capitan
    sha256 "e771dc34da31ff9908e3b6184fa7927a8ed73d773f00e065c28e1b8173bf7fdf" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
