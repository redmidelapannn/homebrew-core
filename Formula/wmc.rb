class Wmc < Formula
  desc "Command-line loader for the WifiMCU platform"
  homepage "https://github.com/zpeters/wmc"
  url "https://github.com/zpeters/wmc/archive/v0.1.2-alpha.tar.gz"
  version "0.1.2-alpha"
  sha256 "b9d3fdc1a6a9cb4fe66081cef6d52e56d4a90a126b0dcb7e26addc6376228d8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "95130a8f6355cceba0385433e57f12337a7a6738da8c6f2a13be47378fabb1ac" => :el_capitan
    sha256 "6c51dcde13d01aed46909b918bf928f3beef1e0b629dba8719203a1de9b470a8" => :yosemite
    sha256 "76103fa148dffd3ab5ab6bfe60b38dd9497245ff6e0d215f51ca88e2410b35ed" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/spf13/viper"
    system "go", "get", "github.com/spf13/cobra"
    system "go", "get", "github.com/tarm/serial"

    system "go", "build", "-o", "wmc"
    bin.install "wmc"
  end

  test do
    system "wmc", "config"
  end
end
