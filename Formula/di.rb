class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.36.tar.gz"
  sha256 "eb03d2ac0a3df531cdcb64b3667dbaebede60a4d3a4626393639cecb954c6d86"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a82a8b21b9cfadc1473f5212177b17431bad96b2bf79a106e87325e63d7240e0" => :el_capitan
    sha256 "507b756c422e94ccbda955e0b740cb071833cf57d426d97e9e78f25684b5cd64" => :yosemite
    sha256 "383da0d489569e028c6ab9372ed11e8387bed9c6316c6974c675516f1c0cf224" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
