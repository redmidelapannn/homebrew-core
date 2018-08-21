class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.0i.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl@1.1--1.1.0i.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.0i.tar.gz"
  sha256 "ebbfc844a8c8cc0ea5dc10b86c9ce97f401837f3fa08c17b2cdadc118253cf99"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "5477c7ed34820957c296af52c76db6b9feb51a38a3e50e896c6c1a3a8dda05ae" => :high_sierra
    sha256 "ec1a267fe425f320c87313586481864f10d30e4246632c2f0d910babe04f1727" => :sierra
    sha256 "3a9d1b0615b6eb94b1d71c24aeec45dc0b55205652be82752435eb70aee42633" => :el_capitan
  end

  devel do
    url "https://www.openssl.org/source/openssl-1.1.1-pre9.tar.gz"
    sha256 "95ebdfbb05e8451fb01a186ccaa4a7da0eff9a48999ede9fe1a7d90db75ccb4c"
  end

  keg_only :versioned_formula

  option "without-test", "Skip build-time tests (not recommended)"

  # Only needs 5.10 to run, but needs >5.13.4 to run the testsuite.
  # https://github.com/openssl/openssl/blob/4b16fa791d3ad8/README.PERL
  # The MacOS ML tag is same hack as the way we handle most :python deps.
  depends_on "perl" if build.with?("test") && MacOS.version <= :mountain_lion

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args; %W[
    --prefix=#{prefix}
    --openssldir=#{openssldir}
    no-ssl3
    no-ssl3-method
    no-zlib
  ]
  end

  def install
    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    if which("perl") == Formula["perl"].opt_bin/"perl"
      ENV["PERL"] = Formula["perl"].opt_bin/"perl"
    end

    if MacOS.prefer_64_bit?
      arch_args = %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128]
    else
      arch_args = %w[darwin-i386-cc]
    end

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "test" if build.with?("test")
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl@1.1"
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
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout >/dev/null", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<~EOS
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
  EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/openssl@1.1/openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
