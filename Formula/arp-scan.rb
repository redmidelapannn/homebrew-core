class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.5.tar.gz"
  sha256 "aa9498af84158a315b7e0ea6c2cddfa746660ca3987cbe7e32c0c90f5382d9d2"
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    rebuild 1
    sha256 "207d363d0a42610e562972a59dd8237338d4bbd6ffc908ac5adf5c06b39bef0e" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap" => :optional

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
