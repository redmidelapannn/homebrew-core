require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.1.tar.gz"
  sha256 "659cd9679fa258ec142cf80ed92282c41aac44152f1193fa804bf00550e64e3a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "f799ec35fb8f248f19e6bc104abcfb2d26aea4cb4728f033aff431631758750f" => :sierra
    sha256 "c9e04292223705bed635b45cd6b27a8a91b54a52bdd8d90268ef8b6a56655903" => :el_capitan
    sha256 "b16891bbe2bdf6d7b4671390eb09804bf6ac71a38583b9989a6052b54bddf703" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "23dd83ae2eeed5be12edc9aa34bb34246cebe866"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Avoid executing `go get`
    inreplace "build/make.go", /\tgetGaugeScreenshot\(\)\n/, ""

    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir

    Language::Go.stage_deps resources, buildpath/"src"
    ln_s "gauge_screenshot", "src/github.com/getgauge/screenshot"

    cd dir do
      system "godep", "restore"
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
