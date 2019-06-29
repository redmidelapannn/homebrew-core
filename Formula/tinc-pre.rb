class TincPre < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://www.tinc-vpn.org/packages/tinc-1.1pre17.tar.gz"
  sha256 "61b9c9f9f396768551f39216edcc41918c65909ffd9af071feb3b5f9f9ac1c27"

  bottle do
    cellar :any
    sha256 "33bc11b4d27170daaf819cf7e6c2006596cbdcd81af5710cf27edbd55f5c8c23" => :mojave
    sha256 "3989b71b77bd4ef4b1f105b5c52b53e23cde681f2e8f6a4421e135db4e8d3ec9" => :high_sierra
    sha256 "7ad685acd42329164fea2a36d474ce3fddde2d7d1dfc5b9ed58a82226eb1d1eb" => :sierra
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
