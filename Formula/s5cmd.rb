# Classname should match the name of the installed package.
class S5cmd < Formula
  desc "Parallel S3 and local filesystem execution tool"
  homepage "https://github.com/peakgames/s5cmd"

  # Source code archive. Each tagged release will have one
  url "https://github.com/peakgames/s5cmd/archive/v0.5.7.tar.gz"
  sha256 "99095c440ba4a1aeb5e1451d2fc8f396dcc401489e9f59cfbad6477bfec419e9"
  head "https://github.com/peakgames/s5cmd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c35b52ec3d008f291a959fdad41c2873b78c5339cbae8dd908cfc075181527d8" => :high_sierra
    sha256 "9c2953fb4aad372e990b4205b175f2d5a8d4f0ca5dcad661f83f7322aef954be" => :sierra
    sha256 "e32f120a4e8146b1e753ce809bf2f57e329c907b1d901bcf4265f494bb607d05" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/peakgames/s5cmd"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/peakgames/s3hash
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-o", bin/"s5cmd"
    end

    ohai "To install shell completion, run s5cmd -cmp-install"
  end

  # Homebrew requires tests.
  test do
    # "2>&1" redirects standard error to stdout.
    assert_match "s5cmd version v0.5.7", shell_output("#{bin}/s5cmd -version 2>&1", 0)
  end
end
