class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.4/rhash-1.3.4-src.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rhash/rhash_1.3.4.orig.tar.gz"
  sha256 "406662c4703bd4cb1caae26f32700951a5e12adf39f141d3f40e0b461b1e9e49"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f6c575a15df41c57cf9190ea6ee823a617d924abf0e9217e4618b6d675f42927" => :sierra
    sha256 "36eabe66a7b93e2a2b0252301227d173a9f23dcc457c386ec4cb1a7ac9a5c208" => :el_capitan
    sha256 "1d479d31921e0864cf2239047e61c46680018a581280165ee0e8dc5d4a74283a" => :yosemite
  end

  # Upstream issue: https://github.com/rhash/RHash/pull/7
  # This patch will need to be in place permanently.
  patch :DATA

  def install
    # install target isn't parallel-safe
    ENV.deparallelize

    system "make", "lib-static", "lib-shared", "all", "CC=#{ENV.cc}"
    system "make", "install-lib-static", "install-lib-shared", "install",
                   "PREFIX=", "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end

__END__
--- a/librhash/Makefile	2014-04-20 14:20:22.000000000 +0200
+++ b/librhash/Makefile	2014-04-20 14:40:02.000000000 +0200
@@ -26,8 +26,8 @@
 INCDIR  = $(PREFIX)/include
 LIBDIR  = $(PREFIX)/lib
 LIBRARY = librhash.a
-SONAME  = librhash.so.0
-SOLINK  = librhash.so
+SONAME  = librhash.0.dylib
+SOLINK  = librhash.dylib
 TEST_TARGET = test_hashes
 TEST_SHARED = test_shared
 # Set variables according to GNU coding standard
@@ -176,8 +176,7 @@

 # shared and static libraries
 $(SONAME): $(SOURCES)
-	sed -n '1s/.*/{ global:/p; s/^RHASH_API.* \([a-z0-9_]\+\)(.*/  \1;/p; $$s/.*/local: *; };/p' $(SO_HEADERS) > exports.sym
-	$(CC) -fpic $(ALLCFLAGS) -shared $(SOURCES) -Wl,--version-script,exports.sym,-soname,$(SONAME) $(LIBLDFLAGS) -o $@
+	$(CC) -fpic $(ALLCFLAGS) -dynamiclib $(SOURCES) $(LIBLDFLAGS) -Wl,-install_name,$(PREFIX)/lib/$@ -o $@
 	ln -s $(SONAME) $(SOLINK)
 # use 'nm -Cg --defined-only $@' to view exported symbols
