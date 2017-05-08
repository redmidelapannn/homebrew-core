class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.2/+download/juju-core_2.1.2.tar.gz"
  sha256 "fba57c0913f77b89f0dc2c73a7c70ebac5263dfb3a014c4f40551beae0a6fd21"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ae871a758c52c7b2db142708fa931632d100cecc0e8001c87618185f61a93e0" => :sierra
    sha256 "ec5f504f6b6800d10097b05cbc718cb4d3539afd0efd30c15c1821669ec3eb96" => :el_capitan
    sha256 "4122637fd872e568078f6a411013aa5af384b54712df5e9cce31b02fc42b1a5b" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-beta3/+download/juju-core_2.2-beta3.tar.gz"
    sha256 "0d041cfa97224cf659444bfe42d16e63c8c4b5e0a3605162a43295b5b0ca0a86"
    version "2.2-beta3"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
