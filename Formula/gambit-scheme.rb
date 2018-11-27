class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.1.tar.gz"
  sha256 "667ae2ee657c22621a60b3eda6e242224d41853adb841e6ff9bc779f19921c18"

  bottle do
    sha256 "205fca54ec97c99efbdb2a6c56c33f2b7112f42db2e9e169ff7ea4eab623c967" => :mojave
    sha256 "b843d983219e31b6a5ff0c350719c427047565421c4b0c2bba656e5f216ad167" => :high_sierra
    sha256 "f2b11cc814f7bb16c5a499eb49e79e9dea8add5066c432bd7f352be673b34fbd" => :sierra
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
