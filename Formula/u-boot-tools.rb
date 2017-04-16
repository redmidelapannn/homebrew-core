class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2017.01.tar.bz2"
  sha256 "6c425175f93a4bcf2ec9faf5658ef279633dbd7856a293d95bd1ff516528ecf2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "89201ce79c714d36e6592997423cac768b2f4d875d71f7ffce4b2cdf487bfdeb" => :sierra
    sha256 "c4754e2642d9219bb0e0de0cf1524cc47458fe6757ddc5c5244efc1097b9ffa8" => :el_capitan
    sha256 "ffdfe70b804096c27fb36d20586c0b4a11062fb0acb7ab0242a5e5302f477852" => :yosemite
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
