class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.1.tar.gz"
  sha256 "667ae2ee657c22621a60b3eda6e242224d41853adb841e6ff9bc779f19921c18"

  bottle do
    sha256 "60fc78e9a2d3801592edb263e4db137b14d4f5255590b9387d631431091a3427" => :mojave
    sha256 "3343d828e656596ae5742e1c29ed2a87c0434a212366950905edfebf933c681c" => :high_sierra
    sha256 "84aa725333b4e9ff7eabbb228e5f201720e927320290acd56f1f3c4ca2d08274" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-poll
      --enable-openssl
    ]

    inreplace "lib/os_io.c" do |s|
      s.gsub! "SSL_CTX_set_default_verify_paths (c->tls_ctx);", ""
      s.gsub! "SSL_CTX_set_verify (c->tls_ctx, SSL_VERIFY_PEER, NULL);", ""
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gsi -e '(for-each write '(0 1 2 3 4 5 6 7 8 9))'")
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
