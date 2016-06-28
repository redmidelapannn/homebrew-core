require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.0.tar.gz"
  sha256 "70078c61ff86a7d1c8c689c8535d06010672027d636f6e624598ec186df4d2e7"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcbc46c7d638aeeee19a2fa98c09ca1c701ea13eb84c226f8388af08a2bb17bb" => :el_capitan
    sha256 "04e2557b3a885de85e401d40daa28938ddeda31fdf73c93315b776de26ae71cf" => :yosemite
    sha256 "0cea05d6a22db134451d2b6799ae3196a7737815dfee62a3eaa6cf27cdd1b855" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
    :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
    :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "04557861f124410b768b1ba5bb3a91b705afbfc6"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "4440cd4f4c2ea31e1872e00de675a86d0c19006c"
  end

  go_resource "github.com/k-takata/go-iscygpty" do
    url "https://github.com/k-takata/go-iscygpty.git",
    :revision => "f91f8810106213f01bd64933dc10d849bd9137ac"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"jvgrep", "jvgrep.go"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
