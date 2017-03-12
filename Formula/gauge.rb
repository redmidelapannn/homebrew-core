require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.1.tar.gz"
  sha256 "2eb6f358cecfa30b8d210aeb3814099bf7fd5f9f88486827e1fc224a5ec65f5b"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    rebuild 1
    sha256 "b2d34c77893a668aa02af4b525726fe4fec09669849df0043858e6def5fb6349" => :sierra
    sha256 "db002dafe9bab0df855fd3d6528fa62006cd73d4171c777228136c07021af061" => :el_capitan
    sha256 "88459ab8bbb44fcb57123e5ce9d0c4abc2238f6569c8ddccce5dfdec41a36257" => :yosemite
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
