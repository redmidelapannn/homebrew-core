class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/releases/download/1.9/arp-scan-1.9.tar.gz"
  sha256 "ce908ac71c48e85dddf6dd4fe5151d13c7528b1f49717a98b2a2535bd797d892"

  bottle do
    rebuild 2
    sha256 "03d7be221f2a2c82d982f7ff1ea0e7923e5d09ef352bdd48262fe9f596597150" => :sierra
    sha256 "287f6b410c6ac780a8dc0ae6d8f416917c047676b77a39755f4b9de5ef4130b0" => :el_capitan
    sha256 "ee413f372649e6ff66cf4148681522c0c7999efb5a96f43c7be3e492a37f164f" => :yosemite
  end

  head do
    url "https://github.com/royhills/arp-scan.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libpcap" => :optional

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
