require "language/go"

class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.3.0.tar.gz"
  sha256 "f6569f3df80c964c0482e7adc1450ea44532d8da887091d099ce42a908fc8136"
  head "https://github.com/technosophos/dashing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ea8006588297ab326360a06434d185cc17ba9c882a5d66bbd1c3fd4d3aac86" => :high_sierra
    sha256 "dd1470b30bbe952a327ad0b8430fd5534a0b9973b5da7700924b513bcf16f017" => :sierra
    sha256 "e11bce70eb680816852355a1578844e42594732fc8b279e94adde7e824fb7b41" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/andybalholm/cascadia" do
    url "https://github.com/andybalholm/cascadia.git"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :tag => "v1.20.0"
  end

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        :tag => "v1.6.0"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :tag => "release-branch.go1.10",
        :revision => "0ed95abb35c445290478a5348a7b38bb154135fd"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "build"
    bin.install "dashing"
  end

  test do
    system "#{bin}/dashing", "create"
    File.exist? "dashing.json"
  end
end
