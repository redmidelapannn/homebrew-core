class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"

  bottle do
    revision 1
    sha256 "4ed4aa7cfcd5c8fc6db6c2b17cc094c6289156cb6d8a4b60e7af82516935a640" => :el_capitan
    sha256 "0d4c55a52baeef22e75bcf34b21d2dab9799b16f2f9c55deb0aa52088747f96a" => :yosemite
    sha256 "11256a972e3f3aaa0a29f78d707e5f3d81fb3d7150dda087b8f40bc54ad87f19" => :mavericks
  end

  depends_on "pcre"

  # Taken from debian
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-builtins=all"
    system "make", "install"
    # Strange but true: using --mandir above causes the build to fail!
    share.install prefix/"man"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index c6f9892..9b93b65 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -22,7 +22,7 @@ WFLAGS_GCC	= -Wshadow -Wpointer-arith -Waggregate-return \
		-Wbad-function-cast -Wsign-compare -Wchar-subscripts \
		-Wcomment -Wformat -Wformat-nonliteral -Wformat-security \
		-Wimplicit -Wmain -Wmissing-braces -Wparentheses \
-		-Wreturn-type -Wswitch -Wmulticharacter \
+		-Wreturn-type -Wswitch \
		-Wmissing-noreturn -Wmissing-declarations @WFLAGS_3X@
 WFLAGS_ICC	= -Wall -wd193,279,810,869,1418,1419
 WFLAGS_3X	= -Wsequence-point -Wdiv-by-zero -W -Wunused \
diff --git a/src/ccze-compat.c b/src/ccze-compat.c
index 0a3c335..5afdc20 100644
--- a/src/ccze-compat.c
+++ b/src/ccze-compat.c
@@ -275,7 +275,7 @@ ccze_getsubopt (char **optionp, char *const *tokens,
 		char **valuep)
 {
   int i = getsubopt (optionp, tokens, valuep);
-#if HAVE_SUBOPTARg
+#if HAVE_SUBOPTARG
   if (!*valuep && suboptarg)
     *valuep = strdup (suboptarg);
 #endif
