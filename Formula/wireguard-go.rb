class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180514.tar.xz"
  sha256 "5a2a0ac5a3c64a9d0c1811d349c6f3f5deb55c15f00f4c13054b897a8c4ac4ae"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bdcebc1f71361643dec0ed79e5080a630fee6ea9823db70146d11dd25d09bd35" => :high_sierra
    sha256 "dae676596f6e90d98da4f7789bfd7c39775a0d780330a2e3b95acb9c7ba41fbc" => :sierra
    sha256 "fb4b5cafc2eac8e0ebc85e99a22f46daf37cb849cff38a0413027f832b4c3cec" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/wireguard-go").install buildpath.children
    cd "src/wireguard-go" do
      system "dep", "ensure", "-vendor-only"
      (buildpath/"gopath/src").install (buildpath/"src/wireguard-go/vendor").children
      ENV["GOPATH"] = buildpath/"gopath"
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
