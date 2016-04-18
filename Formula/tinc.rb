class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.26.tar.gz"
  sha256 "2b4319ddb3bd2867e72532a233f640a58c2f4d83f1088183ae544b268646ba21"

  bottle do
    revision 1
    sha256 "e96af3da5cadd1748169e0253ef945cab1e48593d58d0fc226a51144460b4987" => :el_capitan
    sha256 "846a12a0e4d6ea097a70f0a8c44269107b42c8cdb96e6df8d249c30c415decb5" => :yosemite
    sha256 "d3703e57102babadc617592b99b47b3afc64df440a6774eb1d8856823038b2ae" => :mavericks
  end

  devel do
    url "https://www.tinc-vpn.org/packages/tinc-1.1pre11.tar.gz"
    sha256 "942594563d3aef926a2d04e9ece90c16daf1c700e99e3b91ff749e8377fbf757"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
