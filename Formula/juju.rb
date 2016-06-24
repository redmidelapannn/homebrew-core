class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.5/+download/juju-core_1.25.5.tar.gz"
  sha256 "7667b5695f1117ca48f1b40c24daa60d0b747c8c1c02ff4b96f2f8954688eb90"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3cdbd35a07983df391bcea58883a067dd3385fd32612649318c982b3a1f3447e" => :el_capitan
    sha256 "2815050a69268c8ebd1b26429f3fcf5116aff5d55b2d80722d304043c7da7407" => :yosemite
    sha256 "fd2f9edbde545b2d88db8c92c0ec68324c15a1c9f9ed08e1fab1dc5933058795" => :mavericks
  end

  devel do
    version "2.0-beta10"
    url "https://launchpad.net/juju-core/trunk/2.0-beta10/+download/juju-core_2.0-beta10.tar.gz"
    sha256 "ca1ed827c27b345884aff7e316d54b4929a7e38d6442ffd72d05dd797e8870c8"
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
