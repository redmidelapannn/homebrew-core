class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.14.tar.gz"
  sha256 "bcaee0eaa1ef29ef439d5235b955516871c88d67c3ec5191e3421f65e364e4b8"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "5059ce6e51b561c9e24e9547338d2ac3e12a94f4a913534c260ad08eb191a3e7" => :catalina
    sha256 "7b24cf1143de00950ad3a465e9a84374a6a95e56049788d91e2b8edf00ca646a" => :mojave
    sha256 "8310f89a50fb0a78a8df4f7c74f1de1792d43d9e2fb782afce4314df7585f2c0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"armor", "cmd/armor/main.go"
    prefix.install_metafiles
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/armor --port #{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
