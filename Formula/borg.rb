require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://github.com/ok-borg/borg"
  url "https://github.com/ok-borg/borg/archive/v0.0.3.tar.gz"
  sha256 "d90a55b9c25c2b1fa0c662f1f22fa79f19e77479ad10368756ddf2fa9bee21cc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "97ea040a17bea9f35e21503911bcc9a358c2d89bff09bdff65332cfd614b741e" => :sierra
    sha256 "a58604e7d37e819f359f8d175f026bbcecb9616f0643303941cd1702417aefea" => :el_capitan
    sha256 "e2831618c442c3286008f18e3d48d2a6641e7b586fd394f2df1d39318ce50b51" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "github.com/juju/gnuflag" do
    url "https://github.com/juju/gnuflag.git",
        :revision => "4e76c56581859c14d9d87e1ddbe29e1c0f10195f"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a3f3340b5840cee44f372bddb5880fcbc419b46a"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/ok-borg").mkpath
    ln_s buildpath, buildpath/"src/github.com/ok-borg/borg"
    system "go", "build", "-o", bin/"borg", "github.com/ok-borg/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
