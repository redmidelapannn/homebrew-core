class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.6.tar.gz"
  sha256 "56d1df65e53d716ef7b770dd207cd41ae34f4f97cddca4a7db7018d1021a5843"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "7e5c1a2a3f6a249373009a07b1df65608a6703739c3084a97848017f98ea3476" => :high_sierra
    sha256 "c3ae1d4b7c654d87ce03f6e75b89c4c6bbecd6ad34eb8c340e90950e90664994" => :sierra
    sha256 "d76e0e06c500ede761570f77f43e4fca1a80103aaecc7c26649e33b3671ebb93" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
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
