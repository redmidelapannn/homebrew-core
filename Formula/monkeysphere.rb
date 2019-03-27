class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://web.monkeysphere.info/"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.41.orig.tar.gz"
  sha256 "911a2f1622ddb81151b0f41cf569ccf2154d10a09b2f446dbe98fac7279fe74b"
  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    rebuild 1
    sha256 "996444684bac79863754b856ddda01f42d44afcf8271ef4f646e162368434e44" => :mojave
    sha256 "1f116ede7c49a354d8bcf40ea7b7a524c474936805ed76171eb0d6fbed26b9cc" => :high_sierra
    sha256 "4039f6df4377cfd443529b5f61e0a585347bb358bdcf6c975fb33b2ea526a988" => :sierra
  end

  depends_on "gnu-sed" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl"

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.06.tar.gz"
    sha256 "c7ccafa9108524b9a6f63bf4ac3377f9d7e978fee7b83c430af7e74c5fcbdf17"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Crypt::OpenSSL::Bignum").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    ENV["PREFIX"] = prefix
    ENV["ETCPREFIX"] = prefix
    system "make", "install"

    # This software expects to be installed in a very specific, unusual way.
    # Consequently, this is a bit of a naughty hack but the least worst option.
    inreplace pkgshare/"keytrans", "#!/usr/bin/perl -T",
                                   "#!/usr/bin/perl -T -I#{libexec}/lib/perl5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/monkeysphere v")
    # This just checks it finds the vendored Perl resource.
    assert_match "We need at least", pipe_output("#{bin}/openpgp2pem --help 2>&1")
  end
end
