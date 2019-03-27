class Unac < Formula
  desc "C library and command that removes accents from a string"
  homepage "https://savannah.nongnu.org/projects/unac"
  url "https://deb.debian.org/debian/pool/main/u/unac/unac_1.8.0.orig.tar.gz"
  sha256 "29d316e5b74615d49237556929e95e0d68c4b77a0a0cfc346dc61cf0684b90bf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "77c4929c8a5feecf16ed97e6b3ef94af381bce997e7b132e02cd07057e507676" => :mojave
    sha256 "6790d3251b57d31a5bce12ad4ffc356231a69e77cb1f0510ed9126b7c43f0af2" => :high_sierra
    sha256 "84dedc5f1642a17b8bca50ed77bb58f4a3a4d450c0635790031c31d1f4944ba4" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build

  # configure.ac doesn't properly detect Mac OS's iconv library. This patch fixes that.
  patch :DATA

  patch :p0 do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=patch-libunac1.txt;att=1;bug=623340"
    sha256 "59e98d779424c17f6549860672085ffbd4dda8961d49eda289aa6835710b91c8"
  end

  patch :p0 do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=patch-unaccent.c.txt;att=1;bug=623340"
    sha256 "a2fd06151214400ba007ecd2193b07bdfb81f84aa63323ef3e31a196e38afda7"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/unac/unac_1.8.0-6.diff.gz"
    sha256 "13a362f8d682670c71182ab5f0bbf3756295a99fae0d7deb9311e611a43b8111"
  end

  def install
    chmod 0755, "configure"
    touch "config.rpath"
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Separate steps to prevent race condition in folder creation
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "foo", shell_output("#{bin}/unaccent utf-8 fóó").strip
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 4a4eab6..9f25d50 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,6 +49,7 @@ AM_MAINTAINER_MODE

 AM_ICONV

+LIBS="$LIBS -liconv"
 AC_CHECK_FUNCS(iconv_open,,AC_MSG_ERROR([
 iconv_open not found try to install replacement from
 http://www.gnu.org/software/libiconv/
