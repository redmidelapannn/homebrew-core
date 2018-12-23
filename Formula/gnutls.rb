class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.5.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.5.tar.xz"
  sha256 "073eced3acef49a3883e69ffd5f0f0b5f46e2760ad86eddc6c0866df4e7abb35"

  bottle do
    cellar :any
    rebuild 1
    sha256 "51d6eb3bd4f731ca2f4fba157aa448ef52cffd0d0ae4f4212fff43a39ac1106e" => :mojave
    sha256 "764b204c2507ff4d363aeb6281378b136ba52c745ab9d3c4d71bc5d1f0829c38" => :high_sierra
    sha256 "d52bcc160ac0d4427c42b8ffd13c0f78d9479b1e1f0a15c2fdb6337cd078ce6a" => :sierra
  end

  deprecated_option "with-guile" => "with-guile@2.0"

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit" => :recommended
  depends_on "guile@2.0" => :optional
  depends_on "unbound" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
    ]

    if build.with? "p11-kit"
      args << "--with-p11-kit"
    else
      args << "--without-p11-kit"
    end

    if build.with? "guile"
      args << "--enable-guile" << "--with-guile-site-dir"
    else
      args << "--disable-guile"
    end

    system "./configure", *args
    system "make", "install"

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    keychains = %w[
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(/-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m)

    valid_certs = certs.select do |cert|
      IO.popen("openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir = etc/"openssl"
    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
