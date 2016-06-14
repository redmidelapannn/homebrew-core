class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.25/1.25.5/+download/juju-core_1.25.5.tar.gz"
  sha256 "7667b5695f1117ca48f1b40c24daa60d0b747c8c1c02ff4b96f2f8954688eb90"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "af8026e4237ed61a3422489d1e05f0f1afec0fb13287100139928415dcf086fb" => :el_capitan
    sha256 "bee03dca1b39da780a27098d8c118e0304f68213818b4392a390933e6ac50c13" => :yosemite
    sha256 "3c681967a2be2b4f706e561c5dddbd9e59adff23a4be323f629ead12f66c7af5" => :mavericks
  end

  devel do
    url "https://launchpad.net/juju-core/trunk/2.0-beta8/+download/juju-core_2.0-beta8.tar.gz"
    sha256 "0896e389c5afd7964a5d86e6c3657aedc14896654b6d2e151c90c09d0d98541f"
    version "2.0-beta8"
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
