class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.5/+download/juju-core_1.25.5.tar.gz"
  sha256 "7667b5695f1117ca48f1b40c24daa60d0b747c8c1c02ff4b96f2f8954688eb90"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2c2ea228f996826a375b4295933a75c2e79341f76552ff5fc39e14e8488aa273" => :el_capitan
    sha256 "06e9f8b3d944730badeabfa3a85e38a4c6903ef056951b3dc24b8b73d1bf5f5d" => :yosemite
    sha256 "1af1787e7da2756fc055303917219eb64c5b72b6d8382deb48a56492b8f27407" => :mavericks
  end

  devel do
    url "https://launchpad.net/juju-core/trunk/2.0-beta9/+download/juju-core_2.0-beta9.tar.gz"
    sha256 "0f201909de0c77be21097f7749a32c131606e86a4b5940484d2fe668c108c22b"
    version "2.0-beta9"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    if build.stable?
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
    else
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju2"
    end
  end

  test do
    system "#{bin}/juju", "version"
  end
end
