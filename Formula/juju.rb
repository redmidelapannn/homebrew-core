class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.2/+download/juju-core_2.1.2.tar.gz"
  sha256 "fba57c0913f77b89f0dc2c73a7c70ebac5263dfb3a014c4f40551beae0a6fd21"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9b5358d0cb546f67f98dedfff26e9ae4a3b71c266136f2218fe2ca438c1c76d" => :sierra
    sha256 "8f644a140f87148f97723d2ce8e352ff5ead67b8bcf18ac810fe235f0f92da7b" => :el_capitan
    sha256 "4658e182a7be58526347a639845093aa5f5b97f72b62245c4091c98445588e25" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-beta4/+download/juju-core_2.2-beta4.tar.gz"
    sha256 "592a0f1f47e3a42648d4647a08d159af9d68faf80974ab4171bd4bd22a2200eb"
    version "2.2-beta4"
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
