class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.tar.gz"
  sha256 "ef7a5cb2dbd4b827994519a54d19262e03da3234bab2f175989e3e7b3583999a"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13c5c4bf7446d5985cef9dbc5534d319754b4cd5e661302d5cfa3f2fddda5b3e" => :sierra
    sha256 "16f91037c4d9aa76cb0460d60312d890ece9e36eac3be520e3d48ce2abf80526" => :el_capitan
    sha256 "37739985b104f277ab559de565600734b9ffb9713c04177c8d8af2a1b7985bb0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
