class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2017.01.tar.bz2"
  sha256 "6c425175f93a4bcf2ec9faf5658ef279633dbd7856a293d95bd1ff516528ecf2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "85b4aab3c5313f1866036ef6680e4681443fa74388c9250ad8de1e1788c3dde5" => :high_sierra
    sha256 "0a7f2d2d72b2f7c0c3cf5db931e626e5e0c650741ed86aac0f278068d568241f" => :sierra
    sha256 "4d2b95fa926b1129fded8402d911a38b018b0571b1b125c60a4a64265cc286a9" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
  end
end
