class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.7.tar.gz"
  sha256 "1e04be1274b875a90f3ca1b5685f0e2c2df79ae3b798a1c56395d0b5b5b686b3"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a3f29c7b8160d605b8b98df7ec0b5b1c72e0ed40a783f9609e5f722194dde0ad" => :catalina
    sha256 "861d31951a717576568cb649247a4aad5442c7bc2f1d775fffa4af8d0f0c98a7" => :mojave
    sha256 "9a298be71e47cfcbbac74ab9816667d2feb21b0c4d0b095cbfe7651f86f13d91" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
