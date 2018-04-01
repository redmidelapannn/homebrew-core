class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.2.tar.gz"
  sha256 "bdc8be0856cf3305bb53413b6f79411156a58ec2c87c00cb17aac5c64840f5dd"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dfa419f0906e1688afdfc84969af35713981549fa473056e407864845905a007" => :high_sierra
    sha256 "392ba128e8cf2e54dc2312fc696517ea2d4236435e2814537c6c554b4ee897d4" => :sierra
    sha256 "f800183c328d4532182772a2bfafe2a11129e68b99a1cb1c81cfdc4896627212" => :el_capitan
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
