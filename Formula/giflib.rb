class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.9.tar.bz2"
  sha256 "292b10b86a87cb05f9dcbe1b6c7b99f3187a106132dd14f1ba79c90f561c3295"

  bottle do
    cellar :any
    sha256 "846306029e57af342c92e915bff963460527bbe33d69f7884bd5691d0face9d8" => :mojave
    sha256 "7779f68d9dc3abf18518ee114bee80ab61dd9475b7f3d065f28d0cbe6e86a97e" => :high_sierra
    sha256 "411e4fa20a37bd00d3ca0e43acd1a22ca4e5b7c887e96d4ca92eea620766e584" => :sierra
  end

  patch :p0, :DATA

  def install
    inreplace "Makefile", "USOURCES = qprintf.c quantize.c getarg.c", "USOURCES = qprintf.c quantize.c getarg.c gif_err.c"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end

__END__
--- Makefile	2019-04-02 16:17:24.000000000 -0400
+++ Makefile	2019-04-02 16:10:23.000000000 -0400
@@ -68,13 +68,13 @@
 $(UTILS):: libgif.a libutil.a

 libgif.so: $(OBJECTS) $(HEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libgif.so.$(LIBMAJOR) -o libgif.so $(OBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(OBJECTS) -o libgif.$(LIBMAJOR).dylib

 libgif.a: $(OBJECTS) $(HEADERS)
 	$(AR) rcs libgif.a $(OBJECTS)

 libutil.so: $(UOBJECTS) $(UHEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libutil.so.$(LIBMAJOR) -o libutil.so $(UOBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(UOBJECTS) -o libutil.$(LIBMAJOR).dylib

 libutil.a: $(UOBJECTS) $(UHEADERS)
 	$(AR) rcs libutil.a $(UOBJECTS)
@@ -100,9 +100,8 @@
 install-lib:
 	$(INSTALL) -d "$(DESTDIR)$(LIBDIR)"
 	$(INSTALL) -m 644 libgif.a "$(DESTDIR)$(LIBDIR)/libgif.a"
-	$(INSTALL) -m 755 libgif.so "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBVER)"
-	ln -sf libgif.so.$(LIBVER) "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBMAJOR)"
-	ln -sf libgif.so.$(LIBMAJOR) "$(DESTDIR)$(LIBDIR)/libgif.so"
+	$(INSTALL) -m 755 libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.$(LIBMAJOR).dylib"
+	ln -sf libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.dylib"
 install-man:
 	$(INSTALL) -d "$(DESTDIR)$(MANDIR)/man1"
 	$(INSTALL) -m 644 doc/*.1 "$(DESTDIR)$(MANDIR)/man1"
