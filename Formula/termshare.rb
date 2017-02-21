require "language/go"

class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://github.com/progrium/termshare"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  revision 1

  head "https://github.com/progrium/termshare.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "b40aba9cfe005958ff110ff7f49da7e5c9b18a2fb38457899cb72b5db4e770d3" => :sierra
    sha256 "bdc7636c527951f2118c95bf2b40c4404e12a632911750e1394323898afc8781" => :el_capitan
    sha256 "3aaf247809734af9aa1d86831bba1d0bca72ea9996b8f9d0ae5fef419f19eed5" => :yosemite
  end

  depends_on "go" => :build

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "7553b97266dcbbf78298bd1a2b12d9c9aaae5f40"
  end

  go_resource "github.com/heroku/hk" do
    url "https://github.com/heroku/hk.git",
        :revision => "406190e9c93802fb0a49b5c09611790aee05c491"
  end

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
        :revision => "f7ee69f31298ecbe5d2b349c711e2547a617d398"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
        :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/progrium/termshare"
    path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      # https://github.com/progrium/termshare/issues/9
      inreplace "termshare.go", "code.google.com/p/go.net/websocket",
                                "golang.org/x/net/websocket"
      system "go", "build", "-o", bin/"termshare"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termshare -v")
  end
end
