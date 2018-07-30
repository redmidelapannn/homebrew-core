class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "https://web.archive.org/web/sid.rstack.org/arp-sk/"
  url "https://web.archive.org/web/20180123194412/sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  mirror "http://distcache.freebsd.org/ports-distfiles/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b0054f4c11dbbe8c077d68bdaf199025779f7f4d187961b91da12dfb956cfc00" => :high_sierra
    sha256 "59c4dd981574b0dc4345504d33507cb5806e34a7ff30de6b688bca355ed37500" => :sierra
    sha256 "e40883218ec3dec94cfce1041f07c83f7089d57de3964ddc09bbe3343a9a98ec" => :el_capitan
  end

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libnet=#{Formula["libnet"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "arp-sk version #{version}", shell_output("#{sbin}/arp-sk -V")
  end
end
