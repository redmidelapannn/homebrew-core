class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20181018.tar.xz"
  sha256 "6bedec38d12596d55cfba4b3f7dfa99d5c2555c2f0bf3b3c9a26feb7c6b073ff"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "414f746d7f0f75232a0831b738ad649c1fc0f72833e0fa7541fad45172472da3" => :mojave
    sha256 "4ee1ee142e9930843c0baa631b5901fa873b1c8917263b83bf617bbb20aa119a" => :high_sierra
    sha256 "5b4d9ca62147aa3456e362c7ba4fd14bd3c68b4ae4cd1225ce711e27cb20c3f0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
