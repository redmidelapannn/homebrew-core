class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.3.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.4.3.tar.gz"
  sha256 "bd5726f3e247e7a7d30ce69946d174b8fb92d999d22710c65f176c969812960e"

  bottle do
    rebuild 1
    sha256 "f5013fcb5ffc613fb9d17017cdaa55ac48c0bed9075699ea0beb8f1f4b2c3050" => :sierra
    sha256 "ed811b3e7e169b1d24e267825a5bf10fb4645bd4ae55f0329aa5df54168a6542" => :el_capitan
    sha256 "09de4d6daee2cc08decbbe416e92c85a56c3dee81a8fe1c8fb4b32879ad5ed58" => :yosemite
  end

  devel do
    url "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.5.0.tar.gz"
    mirror "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.5.0.tar.gz"
    version "2.5.0-beta1"
    sha256 "8652bf6b55ab51fb37b686a3f604a2643e0e8fde2c56e6a936027d12afda6eae"
  end

  head do
    url "https://github.com/libressl-portable/portable.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflict with the system OpenSSL."

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
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
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $?.success?
    end

    # LibreSSL install a default pem - We prefer to use macOS for consistency.
    rm_f %W[#{etc}/libressl/cert.pem #{etc}/libressl/cert.pem.default]
    (etc/"libressl/cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the SystemRoots
    keychain. To add additional certificates (e.g. the certificates added in
    the System keychain), place .pem files in
      #{etc}/libressl/certs

    and run
      #{opt_bin}/openssl certhash #{etc}/libressl/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise LibreSSL gets moody.
    assert (HOMEBREW_PREFIX/"etc/libressl/openssl.cnf").exist?,
            "LibreSSL requires the .cnf file for some functionality"

    # Check LibreSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
