class VultrCli < Formula
  desc "Official command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/v0.1.2.tar.gz"
  sha256 "ebf98ab885e0bb5de0f4448af26919df3d2db2114672aea4d2941f88e0f87410"
  head "https://github.com/vultr/vultr-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca3b13a81bdc92d474c931648d1b9dc659d1516c5582b641202645287c24950" => :mojave
    sha256 "16d90e1f17699abc04100bde5878de7565e9dffbf2be14e51779262512e6352a" => :high_sierra
    sha256 "55f01456e0749b88f603c968e8deedca5cdd781f1c07e24aa629136573709097" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    dir = buildpath/"src/github.com/vultr/vultr-cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"vultr-cli", "-ldflags", "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/vultr-cli version 2>&1", 1)
    assert_match "Please export your VULTR API Key", output
  end
end
