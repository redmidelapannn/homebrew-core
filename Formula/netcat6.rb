class Netcat6 < Formula
  desc "Rewrite of netcat that supports IPv6, plus other improvements"
  homepage "https://www.deepspace6.net/projects/netcat6.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  sha256 "db7462839dd135ff1215911157b666df8512df6f7343a075b2f9a2ef46fe5412"

  bottle do
    rebuild 1
    sha256 "cfc219728c492496188f6d61f285c39ff276b9d546283b06ee0425564faf6f2d" => :sierra
    sha256 "0ee4ca385fa2d165fccb148a9b5d1358fe414744bc1ad029b892cd8541eed3ed" => :el_capitan
    sha256 "b18ce8178009e595ebf8ac34579de3ff82d7990b6dfa116e95b5305ad00637c4" => :yosemite
  end

  option "with-silence-patch", "Use silence patch from Debian"

  deprecated_option "silence-patch" => "with-silence-patch"

  patch :p0, :DATA if build.with? "silence-patch"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match "HTTP/1.0", pipe_output("#{bin}/nc6 www.google.com 80", "GET / HTTP/1.0\r\n\r\n")
  end
end

__END__
# wrap socket-type warnings in very_verbose_mode()
--- src/network.c	2006-01-19 14:46:23.000000000 -0800
+++ src/network.c.new	2014-01-17 11:02:10.000000000 -0800
@@ -21,10 +21,11 @@
  */
 #include "system.h"
 #include "network.h"
 #include "connection.h"
 #include "afindep.h"
+#include "parser.h"
 #ifdef ENABLE_BLUEZ
 #include "bluez.h"
 #endif/*ENABLE_BLUEZ*/

 #include <assert.h>
@@ -290,17 +291,20 @@
	assert(sock >= 0);

	/* announce the socket in very verbose mode */
	switch (socktype) {
	case SOCK_STREAM:
-		warning(_("using stream socket"));
+		if (very_verbose_mode())
+			warning(_("using stream socket"));
		break;
	case SOCK_DGRAM:
-		warning(_("using datagram socket"));
+		if (very_verbose_mode())
+			warning(_("using datagram socket"));
		break;
	case SOCK_SEQPACKET:
-		warning(_("using seqpacket socket"));
+		if (very_verbose_mode())
+			warning(_("using seqpacket socket"));
		break;
	default:
		fatal_internal("unsupported socket type %d", socktype);
	}
