class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.10.1.tar.gz"
  sha256 "a1ba39076cc45b24a8763174978805fa93c8713641d0e1715e9ada7d1122ab49"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9e8d26bba98af3b89f1498dcd8a4fd77651af8d734401ac8120c118aa852808" => :high_sierra
    sha256 "eddfe7ce6d45df266adbe9c815c85cd0e4654ab43e440c3ed1d92acc8b0d41a4" => :sierra
    sha256 "b7b52771b8182c411ed7eaa750d33e4941865ebdb729a896155c0779c280c0cd" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags", "-X main.Version=#{version}", "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
