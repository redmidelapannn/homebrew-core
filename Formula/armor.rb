class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.14.tar.gz"
  sha256 "bcaee0eaa1ef29ef439d5235b955516871c88d67c3ec5191e3421f65e364e4b8"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "25d39bc4056257fa90bdf5369e8c48ca57723658781613ea0f03adeab8a02af0" => :mojave
    sha256 "ef81f908f2c061ab3a150337e1bb6a0123675285deb94067325afb816f87441b" => :high_sierra
    sha256 "aeb77b54b10f8ad8bc67191d2808d2217f3914019f1348adff588540f03310b9" => :sierra
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
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
