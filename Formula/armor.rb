class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.3.6.tar.gz"
  sha256 "4385151925a6cf3f1b2ea4a7b5c056d83e856a01a5e8db1c53b824e125ecc3e7"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6696ed9197e7c1640820d845bd7f1b7849245eeb497d5d2fa6cdbbae229db2b6" => :high_sierra
    sha256 "b5b0bbf9ea1bde9fea4703ad55e7ebaa9f8ba465590725548c4cfea3d9896188" => :sierra
    sha256 "9e8fbd7105aef03187c4b32feb2fec7a9439322dffa8ad2b0dc30e60dfcb7d8d" => :el_capitan
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
