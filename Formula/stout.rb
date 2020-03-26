class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "https://github.com/cloudflare/Stout"
  url "https://github.com/cloudflare/Stout/archive/v1.3.2.tar.gz"
  sha256 "33aa533beda7181d5efdcfb9fadcc568f58c1f7e27a4902adf1a6807c4875c99"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "345be481a340e86a0faba35585e6a332e6349215cc4b64061b74bd02c10b1ee8" => :catalina
    sha256 "6cc9b81860a6d12f729930aa305f45b4186941e5d25b938f0955180a6264b87f" => :mojave
    sha256 "2469515dd09251c7d7ea8855e09ddaf9e25f1c452d423cb6a52d0f715bcbc45e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Compatibility with newer Go.
    # Reported upstream, but the project is unmaintained.
    mkdir_p buildpath/"vendor/github.com/sspencer"
    ln_s buildpath/"vendor/github.com/zackbloom/go-ini", buildpath/"vendor/github.com/sspencer/go-ini"

    mkdir_p buildpath/"src/github.com/cloudflare"
    ln_s buildpath, buildpath/"src/github.com/cloudflare/stout"

    system "go", "build", "-o", bin/"stout", "-v", "github.com/cloudflare/stout/src"
  end

  test do
    system "#{bin}/stout"
  end
end
