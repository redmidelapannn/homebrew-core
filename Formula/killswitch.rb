class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/v0.7.2.tar.gz"
  sha256 "21b5f755fd5f23f9785bab6815f83056b0291ea9200706debd490a69aa565558"

  bottle do
    cellar :any_skip_relocation
    sha256 "685fef6971a2464f7bdaac59c0b2f7f9723a39711378e1ab665d04972089dde1" => :catalina
    sha256 "c490d5e6ba5826dc8e7db873419d6291642b4c0a7efa57d3d8aa1c0dffcc097c" => :mojave
    sha256 "b2fa278a3e4de0b3c618064064aef167c4bfb851499d88ba90e925556a2083ed" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", "-ldflags", "-s -w -X main.version=#{version}",
           "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
