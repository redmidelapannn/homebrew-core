class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.7.0.tar.gz"
  sha256 "c19f5b1b4fb374cfe34f4845ea11b1e0551ddc67803bd6ddd5d2a20f0997a6cc"
  revision 1

  bottle do
    rebuild 1
    sha256 "55dfcc019ee3d05d03a951bc2c89728b89c61cc61a346667e34cd17bb0e727f7" => :mojave
    sha256 "be74f7d561ef1551f084c0824b6e6e04658ff5ebda637369127b72f93326ad39" => :high_sierra
    sha256 "673a1e33ad2ba374c45c444eb05d9160598c9e449e3abb5e452140907b3eac75" => :sierra
    sha256 "ac389f3bcdc4d485e632a9718d8d47cbcb7ab113ab490951480101a41e521b13" => :el_capitan
  end

  depends_on "swig" => :build
  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-pyldns
      PYTHON_SITE_PKG=#{lib}/python2.7/site-packages
      --disable-dane-verify
    ]

    system "./configure", *args

    inreplace "Makefile" do |s|
      s.change_make_var! "PYTHON_LDFLAGS", "-undefined dynamic_lookup"
      s.gsub! /(\$\(PYTHON_LDFLAGS\).*) -no-undefined/, "\\1"
    end

    system "make"
    system "make", "install"
    system "make", "install-pyldns"
    (lib/"pkgconfig").install "packaging/libldns.pc"
  end

  test do
    l1 = <<~EOS
      AwEAAbQOlJUPNWM8DQown5y/wFgDVt7jskfEQcd4pbLV/1osuBfBNDZX
      qnLI+iLb3OMLQTizjdscdHPoW98wk5931pJkyf2qMDRjRB4c5d81sfoZ
      Od6D7Rrx
    EOS
    l2 = <<~EOS
      AwEAAb/+pXOZWYQ8mv9WM5dFva8WU9jcIUdDuEjldbyfnkQ/xlrJC5zA
      EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vpNfIRTFadqsmuU9F
      ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04C
      x83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE
      1LpnJI/wcUpRUiuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW
      UbULpRa/il+Cr5Taj988HqX9Xdm6FjcP4Lbuds/44U7U8du224Q8jTrZ
      57Yvj4VDQKc=
    EOS
    (testpath/"powerdns.com.dnskey").write <<~EOS
      powerdns.com.   10773 IN  DNSKEY  256 3 8  #{l1.tr!("\n", " ")}
      powerdns.com.   10773 IN  DNSKEY  257 3 8  #{l2.tr!("\n", " ")}
    EOS

    system "#{bin}/ldns-key2ds", "powerdns.com.dnskey"

    match = "d4c3d5552b8679faeebc317e5f048b614b2e5f607dc57f1553182d49ab2179f7"
    assert_match match, File.read("Kpowerdns.com.+008+44030.ds")
  end
end
