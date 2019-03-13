class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://github.com/enonic/enonic-cli.git",
      :tag      => "1.0.0",
      :revision => "4d549122f2f0b137bd801a3b8ddb24a00a083376"

  bottle do
    cellar :any_skip_relocation
    sha256 "28f1b70e9e3e9f7b2b554e0ae3ad648eb5dcab1686a4145970531350dc3b0ba3" => :mojave
    sha256 "365aafbc47a60858540a3b0206a6ecf7b78d1cb54f775bfcdacff99d1817249b" => :high_sierra
    sha256 "91b07cf5fc44e4a83876bb9c94cccbe822da2a7b9b65deea8873a1c1b0202860" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    revision = Utils.popen_read("git rev-parse HEAD").strip
    today = Date.today
    dir = buildpath/"src/github.com/enonic/enonic-cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.date=#{today}", "-o", bin/"enonic", "./internal/app/cli.go"
    end
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end

