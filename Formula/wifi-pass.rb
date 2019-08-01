class WifiPass < Formula
  desc "Copy, QR encode or just get the password of current Wi-Fi connection"
  homepage "https://wifi-pass.ru"
  url "https://github.com/DaFuqtor/wifi-pass/archive/0.2.7.tar.gz"
  sha256 "c315d03693d707c47ba58e32f3bf9aaf0aa17f799b3838f68a1aa4f77ea9a5cc"
  head "https://github.com/DaFuqtor/wifi-pass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed369572f890fbbddd82e1608deae3e849afab8b780fefea15f5c554e5c361c8" => :mojave
    sha256 "ed369572f890fbbddd82e1608deae3e849afab8b780fefea15f5c554e5c361c8" => :high_sierra
    sha256 "e6572d5ed0fcd6e8b2eb9d1a67873ae0f911b98c6bf0c6378fc3fe917b91b209" => :sierra
  end

  depends_on "qrencode"

  def install
    bin.install "wifi-pass.sh" => "wifi-pass"
  end

  test do
    system "#{bin}/wifi-pass", "-V"
  end
end
