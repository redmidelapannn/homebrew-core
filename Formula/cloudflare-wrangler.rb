class CloudflareWrangler < Formula
  desc "Wrangler is a CLI tool designed for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/tooling/wrangler/"
  url "https://github.com/cloudflare/wrangler/archive/v1.8.0.tar.gz"
  sha256 "ebb31c2549733991823f965025da493bbc2a1644d02668549700793a29df0229"
  head "https://github.com/cloudflare/wrangler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d726cac238cce6ff0411290dce9a3c05d81af57e3605b77821fd0936374419b4" => :catalina
    sha256 "e8a61715057bea3d4d06d362d265d5b68f3e1d31ffac35b82c5edd1a9cf6c817" => :mojave
    sha256 "d5a5510b623fbe8bee730d9bd043578bb331d4c7330081e90cf71e5f7830cdaf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/wrangler", "--help"
    assert_match "wrangler " + version.to_s, shell_output("#{bin}/wrangler -V").chomp
  end
end
