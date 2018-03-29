class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "http://sid.rstack.org/arp-sk/"
  url "http://sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  mirror "http://distcache.freebsd.org/ports-distfiles/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "13473edfbbac32185e2746cb29e80a6d575f1d48b5addb72b143b5f78873e1c7" => :high_sierra
    sha256 "364f830bda757df1badb228da017dcf9deaaaec48df6dcd0c0c69fdc99ffaefb" => :sierra
    sha256 "986fb0bf2049ea70352620bc0cc4bc9b683491ec254a609200f2bfd4c12e1c9e" => :el_capitan
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
