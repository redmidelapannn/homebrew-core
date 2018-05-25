class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180524.tar.xz"
  sha256 "1d539f6c51dd33098a536af0285ef03c561db0ff343f23a75405207fcf48ec3e"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "030748a5be8499dababda5ed8a017154d92ced3152a586db2e81045e864670a0" => :high_sierra
    sha256 "b372a8d12464e515c0a5e94e07e384b604f39af363cb706039a39ed143c910d7" => :sierra
    sha256 "15bd54dfa6e392d850da0a38eccca129f37246ab9ba0a6d69323a196a8619cca" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/wireguard-go", "--version"
  end
end
