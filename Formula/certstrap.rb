class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.2.0.tar.gz"
  sha256 "0eebcc515ca1a3e945d0460386829c0cdd61e67c536ec858baa07986cb5e64f8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d092d05e256a7600a80aad72052fb8d7e743b711a420ce19684bb22495136daf" => :mojave
    sha256 "81bbbe1f9d614f0d703a942f093da943187621162b9a931925c33f8a51756cad" => :high_sierra
    sha256 "819281167b0546cb82939d6fa0014596ea85c038e1896f42f57a3f73d50255a4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/square/certstrap"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-ldflags", "-X main.version=#{version}", "-o", bin/"certstrap"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
