class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.5.tar.gz"
  sha256 "0e0949f6c5b047912a98e7a82723a3b6c1f6206297d67205ee208da3fa19eaa8"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "413ed4eade92c5d4bd73f4e576d0f08995f1fa7dfb707c2741eaafba6ee2ace7" => :sierra
    sha256 "142009c66fe95cb9c7e6a1921237b5aad981cc2fbaf762734000d9c67eab0476" => :el_capitan
    sha256 "2939edc6a7d415a3582b3c20aa4bd807a803289414107a77589afbd2342e550c" => :yosemite
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
