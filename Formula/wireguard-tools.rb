class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180809.tar.xz"
  sha256 "3e351c42d22de427713f1da06d21189c5896a694a66cf19233a7c33295676f19"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a4d795afeeb3bf6e4ac6aa83d640479134335ab47a32ca73c7e12e7354308d0" => :high_sierra
    sha256 "a7381ae7cc7d3993e538022229e81a9d048798ab07d557f134953e07edd0cf3a" => :sierra
    sha256 "15024d0fa60ed5fcb5141749cd2f22d4271186cae7df2d2372f945baff554085" => :el_capitan
  end

  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
