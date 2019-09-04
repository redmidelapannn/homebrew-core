class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.3.1/isync-1.3.1.tar.gz"
  sha256 "68cb4643d58152097f01c9b3abead7d7d4c9563183d72f3c2a31d22bc168f0ea"
  revision 1
  head "https://git.code.sf.net/p/isync/isync.git"

  bottle do
    cellar :any
    sha256 "5a60a0829dd79fca912b684cdf4994559e064253f64021e5d9bc40a1aaf1d3c5" => :mojave
    sha256 "5c8d8dd87e072f15decb68c491f50c18450e3d7e8a55211a443b0f22126de115" => :high_sierra
    sha256 "e07239359fe1f1f6b62a1c86d4f38b56e0715195b1e881a292903be17895bf6d" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db"
  depends_on "openssl@1.1"

  # Patch to fix detection of OpenSSL 1.1
  # https://sourceforge.net/p/isync/bugs/51/
  patch :DATA

  def install
    # Regenerated for HEAD, and because of our patch
    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "isync"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/mbsync</string>
          <string>-a</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
__END__
diff -pur isync-1.3.1/configure.ac isync-1.3.1-fixed/configure.ac
--- isync-1.3.1/configure.ac	2019-05-28 15:44:13.000000000 +0200
+++ isync-1.3.1-fixed/configure.ac	2019-09-07 15:39:55.000000000 +0200
@@ -94,7 +94,7 @@ if test "x$ob_cv_with_ssl" != xno; then
     sav_LDFLAGS=$LDFLAGS
     LDFLAGS="$LDFLAGS $SSL_LDFLAGS"
     AC_CHECK_LIB(dl, dlopen, [LIBDL=-ldl])
-    AC_CHECK_LIB(crypto, CRYPTO_lock, [LIBCRYPTO=-lcrypto])
+    AC_CHECK_LIB(crypto, HMAC_Update, [LIBCRYPTO=-lcrypto])
     AC_CHECK_LIB(ssl, SSL_connect,
                  [SSL_LIBS="-lssl $LIBCRYPTO $LIBDL" have_ssl_paths=yes])
     LDFLAGS=$sav_LDFLAGS
