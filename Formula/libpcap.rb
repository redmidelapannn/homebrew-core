class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.8.1.tar.gz"
  sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ed4e3740b3a14d697183bfe53fa9d7ed7747616f8140c4885feeb1c086fbdbfd" => :high_sierra
    sha256 "e5631d5d7491ce7c16fcbb7deae07bef895da4682ea8b5edd7bdc7ff096ac51b" => :sierra
    sha256 "841ecbc588a4c052a89d953ff8b423da243a76e49a29b7baf20521e597beb06a" => :el_capitan
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    assert_match /lpcap/, shell_output("#{bin}/pcap-config --libs")
  end
end
