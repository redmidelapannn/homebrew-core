class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag      => "1.12.6",
      :revision => "da249c53d427c4cde18f758b2e04ea6ce955e825"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f32c95f6d5ce5d80ae3f1e8cc1947983d428dda85e295702f59ceb40491caca" => :catalina
    sha256 "b62153a21a99935496474631eb60133f7e6ca4ac45e62e8509bc63d5e864642c" => :mojave
    sha256 "d7334edd5c436cd03efa778d910bd660797cde26dcc11c09a9aa17175fad80e0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":45678"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:45678")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
