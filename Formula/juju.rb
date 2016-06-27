class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.5/+download/juju-core_1.25.5.tar.gz"
  sha256 "7667b5695f1117ca48f1b40c24daa60d0b747c8c1c02ff4b96f2f8954688eb90"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9e892f25841af665aecdd0c32ee2ef8694f71d37b98c61e89c84683904cfc3e5" => :el_capitan
    sha256 "469bb6ff0bc587da6012bb5ff320b7f5cf736ac1826f6c84d2cdf40b29a23eb6" => :yosemite
    sha256 "348a30ba39eb175534f919889396bb7757edaa3d58461a705f36f743226426ec" => :mavericks
  end

  devel do
    url "https://launchpad.net/juju-core/1.26/1.26-alpha3/+download/juju-core_1.26-alpha3.tar.gz"
    sha256 "505e995082c3dff885ec6096dd3cdf2f69c177d0eba44b01bae8e84c37033a13"
    version "1.26-alpha3"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
