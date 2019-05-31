class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190531.tar.xz"
  sha256 "8b0280322ec4c46fd1a786af4db0c4d0c600053542c4563582baac478e4127b1"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "86247f2775338129572afee127039ae006330b0ff4904500fadbd505f3f105d6" => :mojave
    sha256 "6f80983db55258cd6d10f1a86a4ff57123f3dda0f9e8cc4078653b90ef77a756" => :high_sierra
    sha256 "41721701230ac166195c1fd7fa2433f8f8295651e65f74323b819ea64e6c84fc" => :sierra
  end

  depends_on "bash"
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
