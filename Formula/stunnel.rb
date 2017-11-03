class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.42.tar.gz"
  mirror "https://www.usenix.org.uk/mirrors/stunnel/stunnel-5.42.tar.gz"
  sha256 "1b6a7aea5ca223990bc8bd621fb0846baa4278e1b3e00ff6eee279cb8e540fab"
  revision 1

  bottle do
    sha256 "27860eee868c5b7db38006522a2279480f4e19febba914eaaf2895e1ab55a5b5" => :high_sierra
    sha256 "705ed215521d390f7ead46dd91695148d26be5c80a5fa071911582a67788fd18" => :sierra
    sha256 "4414e40339714170e873087a67ad66b37bb8637c29257916f8faaa2caa9fbe37" => :el_capitan
  end

  # Please revision me whenever OpenSSL is updated
  # "Update OpenSSL shared libraries or rebuild stunnel"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--disable-systemd",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      args = %w[req -new -x509 -days 365 -rand stunnel.rnd -config
                openssl.cnf -out stunnel.pem -keyout stunnel.pem -sha256 -subj
                /C=PL/ST=Mazovia\ Province/L=Warsaw/O=Stunnel\ Developers/OU=Provisional\ CA/CN=localhost/]
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{Formula["openssl"].opt_bin}/openssl", *args
      chmod 0600, "stunnel.pem"
      (etc/"stunnel").install "stunnel.pem"
    end
  end

  def caveats
    <<~EOS
      A bogus SSL server certificate has been installed to:
        #{etc}/stunnel/stunnel.pem

      This certificate will be used by default unless a config file says otherwise!
      Stunnel will refuse to load the sample configuration file if left unedited.

      In your stunnel configuration, specify a SSL certificate with
      the "cert =" option for each service.
    EOS
  end

  test do
    (testpath/"tstunnel.conf").write <<~EOS
      cert = #{etc}/stunnel/stunnel.pem

      setuid = nobody
      setgid = nobody

      [pop3s]
      accept  = 995
      connect = 110

      [imaps]
      accept  = 993
      connect = 143
    EOS

    output = pipe_output("#{bin}/stunnel #{testpath}/tstunnel.conf 2>&1")
    assert_match "successful", output
    assert_no_match(/Update OpenSSL shared libraries or rebuild stunnel/, output,
      "Please revision bump stunnel.")
  end
end
