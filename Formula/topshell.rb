require "language/node"

class Topshell < Formula
  desc "Purely functional, reactive scripting language"
  homepage "http://show.ahnfelt.net/topshell/"
  url "https://github.com/topshell-language/topshell/archive/v0.7.7.tar.gz"
  sha256 "a24c759b231fbd5aaed3409ed5d12e98ae2987cc27672fef27964a21017dccd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1ffea38a1017b75a6a6d81abf98b9e3291e12f28a2eeff99bbfc8f8b8733066" => :mojave
    sha256 "9a7de128fc977e6778825378b503f4bca3b2f9bd69bc517080f85c6e00a53896" => :high_sierra
    sha256 "e78a711f1f55b34d512898cc20011c1c7b5e7674c73264162ca28225f16e8b28" => :sierra
  end

  depends_on "node" => :build
  depends_on "sbt" => :build

  def install
    system "sbt", "fullOptJS"
    cd "node" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "node_modules/.bin/pkg", "-t", "macos-x64", "package.json"
      bin.install "topshell"
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/topshell"
      end
      sleep 1
      output = shell_output("curl -o /dev/null -s -w '%{http_code}\\n' http://localhost:7070/topshell/index.html")
      assert_match(/200/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
