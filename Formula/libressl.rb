class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.5.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.4.5.tar.gz"
  sha256 "d300c4e358aee951af6dfd1684ef0c034758b47171544230f3ccf6ce24fe4347"

  bottle do
    rebuild 1
    sha256 "accee1efc1fac80c2a06fbb8d4db925707add18b160f155193c2e67675d0a5e2" => :sierra
    sha256 "28109e8c0f0f8b6162f42eab504a681ee37ddb949658ee82d644a8383b4c56d6" => :el_capitan
    sha256 "5565ae526fd8413cccc749b84121bed170e6f6ad2d7cd9671d18f5d4b3a269d3" => :yosemite
  end

  devel do
    url "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.5.1.tar.gz"
    mirror "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.5.1.tar.gz"
    version "2.5.1-beta1"
    sha256 "f71ae0a824b78fb1a47ffa23c9c26e9d96c5c9b29234eacedce6b4c7740287cd"
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
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
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
