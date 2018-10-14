class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.10.0.tar.gz"
  sha256 "ed13a5d9f4cbbe6e82e2ee894cf3c324b2bb209df7eb95f2be10619bbf13d805"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d8b3e42e3cdcd36ace94288f927d37935204b3ca5354ee98d6b972ab20d70521" => :mojave
    sha256 "d4e6452b270d5d1e3af8f6f6600743d34f061a127ba8132482f1920fcb813e41" => :high_sierra
    sha256 "15051bdadd381afa96c91c51583051717954a83f411c118e72b16e6f2312e43e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
