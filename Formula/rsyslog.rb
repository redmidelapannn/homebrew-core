class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-7.4.5.tar.gz"
  sha256 "f5e46e9324e366f20368162b4f561cf7a76fecb4aa0570edcaaa49e9f8c2fe70"
  revision 1

  bottle do
    sha256 "101d11194e7116107d8e42f1a11d2bfe30b7b4b82a83be7625139baa386159ae" => :high_sierra
    sha256 "98c3d7935d0a68ba03a7d4f23f5ee831e888fa939776b7f547b86facc1c18b5e" => :sierra
    sha256 "a0c94f90a5794b6c857ce298489dd18d92f75369a76e2c41e00e58f0979d3620" => :el_capitan
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
diff --git a/runtime/msg.c b/runtime/msg.c
index 039060709..039234517 100644
--- a/runtime/msg.c
+++ b/runtime/msg.c
@@ -42,8 +42,6 @@
 #include <netdb.h>
 #include <libestr.h>
 #include <json.h>
-/* For struct json_object_iter, should not be necessary in future versions */
-#include <json_object_private.h>
 #if HAVE_MALLOC_H
 #  include <malloc.h>
 #endif
