class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.0.2",
    :revision => "fd11248e65c1d04a7a9d3902438d244ad9eef598"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "023f39f58ea40f933c8f3347e7423f65783335062805d7787875161a2b2aa5cb" => :mojave
    sha256 "1279598af18e9a8164b2e5e7fda4ce4e9dc6511a27cd6e8cd7dd7e6fdef8f79c" => :high_sierra
    sha256 "2728a0495fd471b6a34763213d37061f2d7e065d3f7e8016b8bf08c36b0429db" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/go-acme/lego"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
          "-o", bin/"lego", "cmd/lego/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
