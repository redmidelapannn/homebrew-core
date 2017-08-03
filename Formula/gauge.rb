require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.5.tar.gz"
  sha256 "2f6384cfecfd40784c7c5a3280233ea5cf77f82d75c9eee8ebf3652d8a660dac"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    rebuild 1
    sha256 "233e02e8510b0e9291506c79ada19d853a2243521bdb1ef11946e585e13dd37f" => :sierra
    sha256 "703bcb04314e4aa6d51964e30102b08d58a8ae0e0b5dfd5cd732ceea4020be73" => :el_capitan
    sha256 "0e09c5a9790d12ed82941a71ba7c26a723b4e9559647b65f41eb44f42522cc77" => :yosemite
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

  def caveats; <<-EOS.undent
    We are constantly looking to make Gauge better, and report usage statistics anonymously over time.
    If you do not want to participate please read instructions https://manpage.getgauge.io/gauge_telemetry_off.html on how to turn it off.
    EOS
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
