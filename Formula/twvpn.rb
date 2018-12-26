class Twvpn < Formula
  desc "Tool to connect to TWVPN at one click"
  homepage "https://twvpn.wangbaiyuan.cn"
  url "https://github.com/geekeren/twvpn/archive/v0.2.tar.gz"
  sha256 "daf185331faa22e25ac1c42f2903c34535ea7b9fc2d9ce2a02a6e71e3b9a6f81"
  depends_on "oath-toolkit"
  def install
    bin.install "twvpn"
  end

  test do
    system "#{bin}/twvpn", "--version"
  end
end
