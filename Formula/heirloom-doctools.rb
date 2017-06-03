class HeirloomDoctools < Formula
  desc "troff, nroff, and related utilities"
  homepage "https://n-t-roff.github.io/heirloom/doctools.html"
  url "https://github.com/n-t-roff/heirloom-doctools/releases/download/160308/heirloom-doctools-160308.tar.bz2"
  sha256 "e4aeae0e5303537755c04226c06d98a46aa35913d1a179708fbc368f93731a26"

  bottle do
    sha256 "9e6c72d8617ed129c989db3aec4fe69488d6505e8f93b87a4514681932c00d2f" => :sierra
    sha256 "08febd7aabf902c2ccd3f4fdd24a76b8dc663783534774519eab74f800d80aea" => :el_capitan
    sha256 "02e804c795c523d60f5d9cbfb59a053d379563b82540a1c882664ed094c09a04" => :yosemite
  end

  conflicts_with "groff"

  patch :DATA

  def install
    args = "PREFIX=#{prefix}", "BINDIR=#{bin}", "LIBDIR=#{lib}", "MANDIR=#{man}"

    system "./configure"
    system "make", *args
    system "make", "install", *args
  end

  test do
    system "#{bin}/troff", "-V"
  end
end

__END__
diff --git a/eqn/eqn.d/Makefile.mk b/eqn/eqn.d/Makefile.mk
index d6e573c..020c6fe 100644
--- a/eqn/eqn.d/Makefile.mk
+++ b/eqn/eqn.d/Makefile.mk
@@ -34,23 +34,23 @@ clean:
 mrproper: clean

 diacrit.o: ../diacrit.c ../e.h y.tab.h
-eqnbox.o: ../eqnbox.c ../e.h
-font.o: ../font.c ../e.h
-fromto.o: ../fromto.c ../e.h
+eqnbox.o: ../eqnbox.c ../e.h y.tab.h
+font.o: ../font.c ../e.h y.tab.h
+fromto.o: ../fromto.c ../e.h y.tab.h
 funny.o: ../funny.c ../e.h y.tab.h
 glob.o: ../glob.c ../e.h
 integral.o: ../integral.c ../e.h y.tab.h
 io.o: ../io.c ../e.h
 lex.o: ../lex.c ../e.h y.tab.h
 lookup.o: ../lookup.c ../e.h y.tab.h
-mark.o: ../mark.c ../e.h
-matrix.o: ../matrix.c ../e.h
-move.o: ../move.c ../e.h y.tab.h
-over.o: ../over.c ../e.h
-paren.o: ../paren.c ../e.h
-pile.o: ../pile.c ../e.h
-shift.o: ../shift.c ../e.h y.tab.h
-size.o: ../size.c ../e.h
-sqrt.o: ../sqrt.c ../e.h
+mark.o: ../mark.c ../e.h y.tab.h
+matrix.o: ../matrix.c ../e.h y.tab.h
+move.o: ../move.c ../e.h y.tab.h
+over.o: ../over.c ../e.h y.tab.h
+paren.o: ../paren.c ../e.h y.tab.h
+pile.o: ../pile.c ../e.h y.tab.h
+shift.o: ../shift.c ../e.h y.tab.h
+size.o: ../size.c ../e.h y.tab.h
+sqrt.o: ../sqrt.c ../e.h y.tab.h
 text.o: ../text.c ../e.h y.tab.h
 e.o: e.c ../e.h
diff --git a/eqn/neqn.d/Makefile.mk b/eqn/neqn.d/Makefile.mk
index bb924fc..33b6649 100644
--- a/eqn/neqn.d/Makefile.mk
+++ b/eqn/neqn.d/Makefile.mk
@@ -31,23 +31,23 @@ clean:
 mrproper: clean
 
 diacrit.o: ../diacrit.c ../e.h y.tab.h
-eqnbox.o: ../eqnbox.c ../e.h
-font.o: ../font.c ../e.h
-fromto.o: ../fromto.c ../e.h
+eqnbox.o: ../eqnbox.c ../e.h y.tab.h
+font.o: ../font.c ../e.h y.tab.h
+fromto.o: ../fromto.c ../e.h y.tab.h
 funny.o: ../funny.c ../e.h y.tab.h
 glob.o: ../glob.c ../e.h
 integral.o: ../integral.c ../e.h y.tab.h
 io.o: ../io.c ../e.h
 lex.o: ../lex.c ../e.h y.tab.h
 lookup.o: ../lookup.c ../e.h y.tab.h
-mark.o: ../mark.c ../e.h
-matrix.o: ../matrix.c ../e.h
-move.o: ../move.c ../e.h y.tab.h
-over.o: ../over.c ../e.h
-paren.o: ../paren.c ../e.h
-pile.o: ../pile.c ../e.h
-shift.o: ../shift.c ../e.h y.tab.h
-size.o: ../size.c ../e.h
-sqrt.o: ../sqrt.c ../e.h
+mark.o: ../mark.c ../e.h y.tab.h
+matrix.o: ../matrix.c ../e.h y.tab.h
+move.o: ../move.c ../e.h y.tab.h
+over.o: ../over.c ../e.h y.tab.h
+paren.o: ../paren.c ../e.h y.tab.h
+pile.o: ../pile.c ../e.h y.tab.h
+shift.o: ../shift.c ../e.h y.tab.h
+size.o: ../size.c ../e.h y.tab.h
+sqrt.o: ../sqrt.c ../e.h y.tab.h
 text.o: ../text.c ../e.h y.tab.h
 e.o: e.c ../e.h

