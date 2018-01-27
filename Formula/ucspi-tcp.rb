class UcspiTcp < Formula
  desc "Tools for building TCP client-server applications"
  homepage "https://cr.yp.to/ucspi-tcp.html"
  url "https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
  sha256 "4a0615cab74886f5b4f7e8fd32933a07b955536a3476d74ea087a3ea66a23e9c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8ef23f9a28ef34164ad084ce9dd5f25f018ebf7d6738c38b5437d0ec760f212a" => :high_sierra
    sha256 "967bd270d16061b669303c31a86d70e7f30fd6a22d1a6b9e667b37992f9a3601" => :sierra
    sha256 "3106af41472838e616b47b4a208639c33c8fad28daa9e094b1e934c548017957" => :el_capitan
  end

  # IPv6 patch
  # Used to be https://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2
  patch do
    url "https://raw.githubusercontent.com/homebrew/patches/2b3e4da/ucspi-tcp/patch-0.88-ipv6.diff"
    sha256 "c2d6ce17c87397253f298cc28499da873efe23afe97e855bdcf34ae66374036a"
  end

  def install
    (buildpath/"conf-home").unlink
    (buildpath/"conf-home").write prefix

    system "make"
    bin.mkpath
    system "make", "setup"
    system "make", "check"
    share.install prefix/"man"
  end

  test do
    assert_match(/usage: tcpserver/,
      shell_output("#{bin}/tcpserver 2>&1", 100))
  end
end
