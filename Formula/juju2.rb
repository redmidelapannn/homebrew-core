class Juju2 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0-rc1/+download/juju-core_2.0-rc1.tar.gz"
  sha256 "bef47f4d4e929a71c0934a782043fecc409a76ca4e73fbe3406415226077f745"

  bottle do
    cellar :any_skip_relocation
    sha256 "e44380d4a5b65063833f04b2afee7bc5e2ddab0f850a3d5e0c0bcd4acf4a36a6" => :sierra
    sha256 "b686593c3f7787bba7518c00efe61e11489b3f6919edb2dc33f8c1ecb04e8c19" => :el_capitan
    sha256 "636bc0dbc4d0b30a38760ffe4c49030fd548230305948f3d73ef4212c42647ff" => :yosemite
  end

  depends_on "go" => :build
  conflicts_with "juju", because: "juju and juju2 cannot be installed simultaneously, and juju environments aren't compatible with juju2"

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
