class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.16.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.16.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.4/gnutls-3.4.16.tar.xz"
  sha256 "d99abb1b320771b58c949bab85e4b654dd1e3e9d92e2572204b7dc479d923927"

  bottle do
    cellar :any
    rebuild 1
    sha256 "89a4f3a08bae432e1bba81756542cbdbedb5da89e1ff59f92ecec547e7104d91" => :sierra
    sha256 "ed8326b506294241d61ca904380721f4dbacbd2e2dacbfbd0f7ccda01c2779d3" => :el_capitan
    sha256 "d765f08afcb40a705af1b58c6469dbd24cd5a254cb0ea6be7bc16c99a7144713" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "guile" => :optional
  depends_on "unbound" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    # Fix "dyld: lazy symbol binding failed: Symbol not found: _getentropy"
    # Reported 18 Oct 2016 https://gitlab.com/gnutls/gnutls/issues/142
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "getentropy(0, 0);", "undefinedgibberish(0, 0);"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
      --without-p11-kit
    ]

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
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
    )

    valid_certs = certs.select do |cert|
      IO.popen("openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $?.success?
    end

    openssldir = etc/"openssl"
    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
