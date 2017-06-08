class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.1/2.1.3/+download/juju-core_2.1.3.tar.gz"
  sha256 "cc0436d1474d3d87d7d2193bab271d647640db2ce115f2fb9dd71b92b019d7d0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ce0bf14cfdb221b1f5f655ea1092a72d220d2d16561c13b2f1b74c8ee86bf85c" => :sierra
    sha256 "b7bd43135d17003034caccab17f18ce51b5a5dd19ccb7b4159e0a5623ef81282" => :el_capitan
    sha256 "63774efc2e55f5da82787df3183c43dd2cab1dbe0009a7cec94641c77d628cf1" => :yosemite
  end

  devel do
    url "https://launchpad.net/juju/2.2/2.2-rc1/+download/juju-core_2.2-rc1.tar.gz"
    sha256 "3e81cd96c8737805ad0a31c37b7b6c72e1e28a73d28b81defe9c500d51df00bc"
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
