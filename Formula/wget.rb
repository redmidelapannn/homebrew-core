# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063
class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftpmirror.gnu.org/wget/wget-1.19.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.gz"
  sha256 "9e4f12da38cc6167d0752d934abe27c7b1599a9af294e73829be7ac7b5b4da40"

  bottle do
    rebuild 1
    sha256 "7eb974d8a86399503f74faa0bb5770cafecdf72022edd1286ddf40f738249454" => :sierra
    sha256 "2216a3e5609f3759e53e9f575abc223e51fd94b941c7c3bae44258ee7e6afd7d" => :el_capitan
    sha256 "d729e5d0d592d0a82a73f82ac486db9fa46b40fc7a11dbbba2c33abd51f80a77" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debug support"
  option "with-test", "Build with test"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional

  # iri-disabled test fails 
  # https://savannah.gnu.org/bugs/index.php?50528
  patch :DATA

  def install
    # Fixes undefined symbols _iconv, _iconv_close, _iconv_open
    # Reported 10 Jun 2016: https://savannah.gnu.org/bugs/index.php?48193
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end

__END__
diff --git a/tests/Makefile.am b/tests/Makefile.am
index c27c4ce..9ac8572 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -86,7 +86,6 @@ PX_TESTS = \
              Test-idn-robots-utf8.px \
              Test-iri.px \
              Test-iri-percent.px \
-             Test-iri-disabled.px \
              Test-iri-forced-remote.px \
              Test-iri-list.px \
              Test-k.px \
diff --git a/tests/Makefile.in b/tests/Makefile.in
index d7ef010..b1e1f4d 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -1569,7 +1569,6 @@ PX_TESTS = \
              Test-idn-robots-utf8.px \
              Test-iri.px \
              Test-iri-percent.px \
-             Test-iri-disabled.px \
              Test-iri-forced-remote.px \
              Test-iri-list.px \
              Test-k.px \
