class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.2/+download/juju-core_2.1.2.tar.gz"
  sha256 "fba57c0913f77b89f0dc2c73a7c70ebac5263dfb3a014c4f40551beae0a6fd21"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0c419a3487b135fdddfbe0684e18bb8cdafc86be0042e3ed00f0ce80d959428b" => :sierra
    sha256 "729c0cfcac38228c549930b135c56752ca18e1608ad594eaa262121c133a23c7" => :el_capitan
    sha256 "3cc2238b8be867401a1331a40b3fcc473b1913bc5d0ffd050aed469f829456db" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-beta1/+download/juju-core_2.2-beta1.tar.gz"
    sha256 "1f0a27c13c19521f938f703c6f797a682d33f88f1c58c7826040388c192d43a8"
    version "2.2-beta1"
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
