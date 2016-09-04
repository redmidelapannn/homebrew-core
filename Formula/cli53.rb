class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.0.tar.gz"
  sha256 "0a87de05110d9bba851ba3522a1072494256e31fa653f59331313bff21d5c160"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f66208f4118336a41c72576ef51557ccc28e9e889dd4333e0f81bba63bd5330a" => :el_capitan
    sha256 "8c08731f23db1dce835ee8979bad3ed9f93d3f2c9480bd92bec75b5f54adcf33" => :yosemite
    sha256 "ae5cf616fc0ac935d1061ed8b45a41504ec67c2c8eb36ae5129a7260b55339cb" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
