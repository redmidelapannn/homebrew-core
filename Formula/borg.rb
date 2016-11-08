require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://ok-b.org/"
  url "https://github.com/crufter/borg/archive/v0.0.2.tar.gz"
  sha256 "e1b24f34a5b391e910af5aa903a376106c6328389b0accadbca231822ca1ff32"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1a6295e2e6d7367532ca0de2ab08003349d2b5ebfee1cb21b8898f0f99fe2bb6" => :sierra
    sha256 "6b2f3a7b10f2a48ae2c584c11899a9ae4a9b9bdbbe56844f90e0cb35985fda19" => :el_capitan
    sha256 "dcd2cf6721441b124020c981afce3fc7ad465f3b9fd5ea0b997a14866bc14cdd" => :yosemite
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
