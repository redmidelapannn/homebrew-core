class Whatmask < Formula
  desc "Network settings helper"
  homepage "http://www.laffeycomputer.com/whatmask.html"
  url "https://web.archive.org/web/20170107110521/downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz"
  sha256 "7dca0389e22e90ec1b1c199a29838803a1ae9ab34c086a926379b79edb069d89"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ccd1a7907defc301d7d1997c3ae6b00a559feb0d5299461b8c8e03b4bc1f5e15" => :mojave
    sha256 "ee335c24b2b1bcce891900dbaf2791dddb0333134cdd75f9655c81e18790d1e4" => :high_sierra
    sha256 "eccff7f7e6bd6d18e82a4a36fd5fa8bf7f3b3a31ff34a38458c099a51e418c0a" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/whatmask /24")

      ---------------------------------------------
             TCP/IP SUBNET MASK EQUIVALENTS
      ---------------------------------------------
      CIDR = .....................: /24
      Netmask = ..................: 255.255.255.0
      Netmask (hex) = ............: 0xffffff00
      Wildcard Bits = ............: 0.0.0.255
      Usable IP Addresses = ......: 254

    EOS
  end
end
