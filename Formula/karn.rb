require "language/go"

class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.3.tar.gz"
  sha256 "a9336abe63dbf6b952e1e4a3d4c31ed62dda69aa51e53f07902edb894638162d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0641c45eccb969d6c927017cf09c66d301799ba09f29f0e0426a48cc06aa30cb" => :el_capitan
    sha256 "ce1e53b2f37c92adae2393c696ec7d5f5bab362e3d7e55b420642fccb729bc19" => :yosemite
    sha256 "ad7e16efa7ec5814aa393d6ea050a6e6c0589731057c59f40d2d444d3ba0988a" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "a889873af50a499d060097216dcdbcc26ed09e7c"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prydonius"
    ln_s buildpath, buildpath/"src/github.com/prydonius/karn"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/karn/karn.go"
    bin.install "karn"
  end

  test do
    (testpath/".karn.yml").write <<-EOS.undent
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end
