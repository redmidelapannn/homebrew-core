class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "96fe4a1e473ae143847d7b52c124e81463c5942b1bb69e2124b7c13614494ef1" => :catalina
    sha256 "8030e0b1850a3a0957143bf5742f81653ec318c46e87d63385c780d958d95299" => :mojave
    sha256 "edda34b2c0f615b42ad0b3cd0eee5a9de8d267cd9700f4e4021e99859860d414" => :high_sierra
  end

  depends_on "openssl@1.1"

  # Patch for OpenSSL 1.1 compatibility
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/dmg2img/openssl-1.1.diff"
    sha256 "bd57e74ecb562197abfeca8f17d0622125a911dd4580472ff53e0f0793f9da1c"
  end

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
