class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "http://www.rsyslog.com"
  url "http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.4.5.tar.gz"
  sha256 "f5e46e9324e366f20368162b4f561cf7a76fecb4aa0570edcaaa49e9f8c2fe70"

  bottle do
    rebuild 1
    sha256 "bb0f3b8b2bee5db24e4f0a991ae7e4ba4335c89ad7ae1cae696fdfaf0108cb06" => :high_sierra
    sha256 "1432b8c0fdeedb38537bcc0fcd13de5f95c073772990e30fa62dae32e7ec8b91" => :sierra
    sha256 "89833b8a96bdefc30e07f5b8e05197f9849d1f2b18e8ac87e2f3ce09b979daff" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libestr"
  depends_on "json-c"

  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-imfile
      --enable-usertools
      --enable-diagtools
      --enable-cached-man-pages
      --disable-uuid
      --disable-libgcrypt
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  plist_options :manual => "rsyslogd -f #{HOMEBREW_PREFIX}/etc/rsyslog.conf -i #{HOMEBREW_PREFIX}/var/run/rsyslogd.pid"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/rsyslogd</string>
          <string>-n</string>
          <string>-f</string>
          <string>#{etc}/rsyslog.conf</string>
          <string>-i</string>
          <string>#{var}/run/rsyslogd.pid</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/rsyslogd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/rsyslogd.log</string>
      </dict>
    </plist>
    EOS
  end
end

__END__
diff --git i/grammar/parserif.h w/grammar/parserif.h
index aa271ec..03c4db9 100644
--- i/grammar/parserif.h
+++ w/grammar/parserif.h
@@ -3,7 +3,7 @@
 #include "rainerscript.h"
 int cnfSetLexFile(char*);
 int yyparse();
-char *cnfcurrfn;
+extern char *cnfcurrfn;
 void dbgprintf(char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void parser_errmsg(char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void tellLexEndParsing(void);
