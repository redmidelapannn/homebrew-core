class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.3/+download/juju-core_2.0.3.tar.gz"
  sha256 "b37e78b91c5d96ddd28044b645f4fe7144f7c44e55ddc2dfea2ad134101a4ed0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cec227c7119eccdc07b7685e6a9fea1c64a4f8438614c475e9d4f08d3077b631" => :sierra
    sha256 "ce566657ca664eb445d8173dfc479fe68b45197bfa11afeffcd7d39afbee0641" => :el_capitan
    sha256 "a9e3453dfd69865470094cb4eb3029724c14652510a6706a0ccc28236cc00097" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.1/2.1-rc1/+download/juju-core_2.1-rc1.tar.gz"
    sha256 "dde7058b904d167c671e68a6915f6448bdcb04f2102923e136e28dac15c2e229"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    if build.stable?
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
    else
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
    end
  end

  test do
    system "#{bin}/juju", "version"
  end
end
