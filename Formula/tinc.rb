class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.35.tar.gz"
  sha256 "18c83b147cc3e2133a7ac2543eeb014d52070de01c7474287d3ccecc9b16895e"

  bottle do
    rebuild 1
    sha256 "9c1346ef93e3948ab511cdd6c139994c51eb95350a934f0a8ee6e7bdd9b52e44" => :mojave
    sha256 "79ad67610c45593b0b7532e46a934bbb0e892b3881c3cad537cd6065ae900430" => :high_sierra
    sha256 "89639ad03be8c9a18ba54c085d2497c6c3a6cc789ed371ab2bbba21cf122b4e5" => :sierra
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
