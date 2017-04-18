class GitGrab < Formula
  desc "Git subcommand the organizes git repos while cloning."
  homepage "https://github.com/jmcgarr/git-grab"
  url "https://github.com/jmcgarr/git-grab/archive/0.2.tar.gz"
  version "0.2.0"
  sha256 "3452bba14cb4625da2da5ee6d08061356e647309cea149787b7aaaaf1db25406"

  head "https://github.com/jmcgarr/git-grab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "819357b2da9ff5706beaa95f307c3eea5cdb5850d455fa053ecd2a39ac5215d1" => :sierra
    sha256 "88198c8a5fc3a50a32a9a29b051d56d26b786e9947130bc913ca60b61dc3d7a6" => :el_capitan
    sha256 "cd5fdba6296696e024014a39ad6e95be4b9bd1b7e60d29f5b192e8181e1ba3d0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "github.com/op/go-logging"

    # Build and install git-grab
    system "go", "build", "-o", "git-grab"
    bin.install "git-grab"
  end

  test do
    system "git", "grab"
  end
end
