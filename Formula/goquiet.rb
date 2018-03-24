require "language/go"

class Goquiet < Formula
  desc "Shadowsocks plugin that obfuscates the traffic"
  homepage "https://github.com/cbeuw/GoQuiet"
  url "https://github.com/cbeuw/GoQuiet/archive/v1.1.1.tar.gz"
  sha256 "55f92df1dcf892d7aaccd0331d917a41286dafb5a7d8fa7b8d2d257dc385314f"

  bottle do
    cellar :any_skip_relocation
    sha256 "49aeaeac8cd8dd43db9b00a66741f033f0f24774fe061bd3de1fc07df01aa4bc" => :high_sierra
    sha256 "a7d90cd4109b718c2c20f52a2a2fa7cb25f5359a277b20aeb4da5855852e441f" => :sierra
    sha256 "53c517da00591bab6392373d4087f6bcf629af8af2d8f975f157b8c43a081b40" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/cbeuw/gotfo" do
    url "https://github.com/cbeuw/gotfo.git",
        :revision => "e8588a8e0499d45affbdedf940842dbfb2805cd0"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/cbeuw").mkpath
    ln_s buildpath, "src/github.com/cbeuw/GoQuiet"

    system "make"
    bin.install Dir["build/*"]
    prefix.install_metafiles
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/gq-client -h 2>&1", 2)
    assert_match "Usage of", shell_output("#{bin}/gq-server -h 2>&1", 2)
  end
end
