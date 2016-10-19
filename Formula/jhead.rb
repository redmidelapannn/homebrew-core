class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.00.tar.gz"
  sha256 "88cc01da018e242fe2e05db73f91b6288106858dd70f27506c4989a575d2895e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f8d660e20ab7647ffb6e7fa9f7ed54002708c0758d3ad7ea0e83b885f83a8e4" => :sierra
    sha256 "26ee78cb356f53660f3904303cebf38b4a4514b3e4b96dcbb616ab2181e22ea8" => :el_capitan
    sha256 "a3b73e9e8e68d3d2c15b00a6b425a9974ca4dc0c61b7fefb342152d947f43bb5" => :yosemite
  end

  depends_on "jpeg"

  # Patch to provide a proper install target to the Makefile. The patch has
  # been submitted upstream through email. We need to carry this patch until
  # upstream decides to incorporate it.
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end

__END__
--- a/makefile	2015-02-02 23:24:06.000000000 +0100
+++ b/makefile	2015-02-25 16:31:21.000000000 +0100
@@ -1,12 +1,18 @@
 #--------------------------------
 # jhead makefile for Unix
 #--------------------------------
+PREFIX=$(DESTDIR)/usr/local
+BINDIR=$(PREFIX)/bin
+DOCDIR=$(PREFIX)/share/doc/jhead
+MANDIR=$(PREFIX)/share/man/man1
 OBJ=.
 SRC=.
 CFLAGS:= $(CFLAGS) -O3 -Wall

 all: jhead

+docs = $(SRC)/usage.html
+
 objs = $(OBJ)/jhead.o $(OBJ)/jpgfile.o $(OBJ)/jpgqguess.o $(OBJ)/paths.o \
	$(OBJ)/exif.o $(OBJ)/iptc.o $(OBJ)/gpsinfo.o $(OBJ)/makernote.o

@@ -19,5 +25,8 @@
 clean:
	rm -f $(objs) jhead

-install:
-	cp jhead ${DESTDIR}/usr/local/bin/
+install: all
+	install -d $(BINDIR) $(DOCDIR) $(MANDIR)
+	install -m 0755 jhead $(BINDIR)
+	install -m 0644 $(docs) $(DOCDIR)
+	install -m 0644 jhead.1 $(MANDIR)
