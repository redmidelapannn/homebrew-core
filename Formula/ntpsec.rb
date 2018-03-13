class Ntpsec < Formula
  desc "Secure and hardened implementation of Network Time Protocol"
  homepage "https://www.ntpsec.org"
  url "ftp://ftp.ntpsec.org/pub/releases/ntpsec-1.0.0.tar.gz"
  sha256 "7727e67679812200c52a4c8114bb140f217a4303ec52326c449c15cc470c1700"

  bottle do
    cellar :any
    sha256 "dddd2e37e911f93666687bcabe50aedc3a9e01227ddaf75bc378e25b5134cfad" => :high_sierra
    sha256 "eb1a9349fb41e4aa128fdd66edde1bdd16fa976e01e56cb3fe64b213f090bff2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./waf", "configure", "--prefix=#{prefix}",
                    "--pythondir=#{lib}/python2.7/site-packages"
    system "./waf"
    system "./waf", "install"
  end

  test do
    assert_match "maximum error", shell_output("#{bin}/ntptime")
  end
end
