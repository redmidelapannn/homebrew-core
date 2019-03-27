class Iprint < Formula
  desc "Provides a print_one function"
  homepage "https://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "https://deb.debian.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  version "1.3-9"
  sha256 "1079b2b68f4199bc286ed08abba3ee326ce3b4d346bdf77a7b9a5d5759c243a3"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "7f9ee6cb46090dad5937ff28c67501977c440a4ce3321559ca533cbd815397dd" => :mojave
    sha256 "a00169ac99620e8215c9c154a56893eff1813b1628283055efadccbdbf3622f6" => :high_sierra
    sha256 "9ab6ee097fc52f0017ead9a5d0b21569dda229411b76de5d4c3bf90a34f8d216" => :sierra
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    sha256 "3a1ff260e6d639886c005ece754c2c661c0d3ad7f1f127ddb2943c092e18ab74"
  end

  def install
    system "make"
    bin.install "i"
    man1.install "i.1"
  end

  test do
    assert_equal shell_output("#{bin}/i 1234"), "1234 0x4D2 02322 0b10011010010\n"
  end
end
