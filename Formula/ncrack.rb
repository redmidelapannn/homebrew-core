class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://nmap.org/ncrack/dist/ncrack-0.5.tar.gz"
  sha256 "dbad9440c861831836d47ece95aeb2bd40374a3eb03a14dea0fe1bfa73ecd4bc"
  head "https://github.com/nmap/ncrack.git"

  bottle do
    rebuild 1
    sha256 "462e5372874f8c9a8272f281d71cdc84fe4dd14c02d9b387be254c4935e49d4f" => :high_sierra
    sha256 "899e9f5a98cc7357ae9190ee3a666bb6b2956aa47ecff3976171ccf1c8c0a6e7" => :sierra
    sha256 "a9988074da7f7949f7bb5e3c13a4d30d9a6fc49900c5a64d528873d8c82e81ec" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("\nNcrack version 0.5 ( http://ncrack.org )\nModules: FTP, SSH, Telnet, HTTP(S), POP3(S), SMB, RDP, VNC, SIP, Redis, PostgreSQL, MySQL", shell_output(bin/"ncrack --version"))
  end
end
