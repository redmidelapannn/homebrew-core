require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://github.com/ok-borg/borg"
  url "https://github.com/crufter/borg/archive/v0.0.2.tar.gz"
  sha256 "e1b24f34a5b391e910af5aa903a376106c6328389b0accadbca231822ca1ff32"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d8fd6c63f26bbfbf3abcbf3485bf3b9a3d658b1c5f36df6c5efc4cfa5307eb8e" => :sierra
    sha256 "d78c9ec63ac039631d6236efebf5bb2e2c045b8a817e67ee21ca3fab9e096ddf" => :el_capitan
    sha256 "b983cb2897d69bf9cef4a0ad163dc06a4e8519371922eef6e6255c309f58a062" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/juju/gnuflag" do
    url "https://github.com/juju/gnuflag.git",
        :revision => "4e76c56581859c14d9d87e1ddbe29e1c0f10195f"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a5b47d31c556af34a302ce5d659e6fea44d90de0"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/crufter").mkpath
    ln_s buildpath, buildpath/"src/github.com/crufter/borg"
    system "go", "build", "-o", bin/"borg", "github.com/crufter/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
