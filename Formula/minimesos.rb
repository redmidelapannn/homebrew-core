class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.10.2.tar.gz"
  sha256 "16b198078c9384426f8849b08e92e173816c4d6626331bc6569aa5de89dffbdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c60a5566df04fc822f621e6db6c090a2eeeca4cf0f36fb2dd9250e9ab6f647df" => :sierra
    sha256 "c60a5566df04fc822f621e6db6c090a2eeeca4cf0f36fb2dd9250e9ab6f647df" => :el_capitan
    sha256 "c60a5566df04fc822f621e6db6c090a2eeeca4cf0f36fb2dd9250e9ab6f647df" => :yosemite
  end

  depends_on "docker"

  def install
    bin.install "bin/minimesos"
  end

  test do
    assert_match "Docker", shell_output("#{bin}/minimesos --help 2>&1", 125)
  end
end
