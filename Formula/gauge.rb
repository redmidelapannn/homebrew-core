require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.1.tar.gz"
  sha256 "659cd9679fa258ec142cf80ed92282c41aac44152f1193fa804bf00550e64e3a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "8e5d9439407930359029cd30cb63367203a0c63e614893aa7428248877b09d6f" => :sierra
    sha256 "3c4d45043f961a86af2dc4f17091b743e5245e1fd2fac99ed3567771e18ab217" => :el_capitan
    sha256 "aafdc3edbd1021dc285070504daea45983e7c2fc65a37d6eaaf972d76976dc05" => :yosemite
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
