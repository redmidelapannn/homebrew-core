class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.4.tar.gz"
  sha256 "4d23cb9e604e715d69c3d3c9e091e33cf34ae5d07b1162581a7dc3e550ab90ef"
  head "https://github.com/labstack/armor.git"

  bottle do
    sha256 "5bf4096dc93018713b54391c66c8236194f8bcd9577f3707b47a7185e81332d9" => :sierra
    sha256 "c93df0dc65f87d9e4bc48bfb1e27991e7371e0a736e50567ed126fd95fd2b338" => :el_capitan
    sha256 "0216ff68a117070c10e42f9c5414be201b39dbde55e7cb921726d85c59d51c77" => :yosemite
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
