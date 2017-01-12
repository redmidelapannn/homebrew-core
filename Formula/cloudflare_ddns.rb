class CloudflareDdns < Formula
  desc "Cloudflare Dynamic DNS Updater"
  homepage "https://github.com/wyattjoh/cloudflare-ddns"
  url "https://github.com/wyattjoh/cloudflare-ddns/archive/v1.0.1.tar.gz"
  sha256 "e13ab6c203eb646ebb23384c0136f469b8e72b05d31f43f288ff9671e601809c"
  head "https://github.com/wyattjoh/cloudflare-ddns.git"

  bottle do
    sha256 "087155e33698e48e0b6e128fef162bacb632a16f761cf765a1b45645c1183e97" => :sierra
    sha256 "7ffe173b78524355cb630ff780c864ae864dd34db5667d724524d0ac17eb7035" => :el_capitan
    sha256 "4fc2aa0480ba51d853b9404163337303450939d55c2414c1ff23205bae7975b0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/wyattjoh/cloudflare-ddns"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"cloudflare-ddns"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cloudflare-ddns", "--help"
  end
end
