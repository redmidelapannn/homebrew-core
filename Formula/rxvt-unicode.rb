class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2"
  sha256 "e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd"
  revision 3

  bottle do
    rebuild 1
    sha256 "f7b65d84dc492ea08d92ce3ad85c4a7ca6ce62ad8081eb2622c0aa776337a439" => :mojave
    sha256 "a2d4b0429526ab58baac70e7922445c0ed37375a8322cb6bb2e0d8d5091b22d5" => :high_sierra
    sha256 "810ad5ab80b04d03ce0412ddbc6315109dc604e215013ef55d8606236585fd82" => :sierra
    sha256 "28958951321b8b29ca594381aceb545c5deb749ca9397d1b02ad29f0f556c7f3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :x11

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
      --enable-unicode3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    daemon = fork do
      system bin/"urxvtd"
    end
    sleep 2
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

__END__
diff --git a/configure b/configure
index c756724..5e94907 100755
--- a/configure
+++ b/configure
@@ -7847,8 +7847,8 @@ $as_echo_n "checking for $PERL suitability... " >&6; }

      save_CXXFLAGS="$CXXFLAGS"
      save_LIBS="$LIBS"
-     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts`"
-     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts`"
+     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
      cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */

@@ -7884,8 +7884,8 @@ $as_echo "#define ENABLE_PERL 1" >>confdefs.h

         IF_PERL=
         PERL_O=rxvtperl.o
-        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts`"
-        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts`"
+        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
         PERLPRIVLIBEXP="`$PERL -MConfig -e 'print $Config{privlibexp}'`"
      else
         as_fn_error $? "no, unable to link" "$LINENO" 5
diff --git a/Makefile.in b/Makefile.in
index eee5969..c230930 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -31,6 +31,7 @@ subdirs = src doc

 RECURSIVE_TARGETS = all allbin alldoc tags clean distclean realclean install

+.PHONY: install
 #-------------------------------------------------------------------------

 $(RECURSIVE_TARGETS):
