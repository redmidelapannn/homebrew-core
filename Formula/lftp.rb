class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.4.tar.xz"
  sha256 "4ebc271e9e5cea84a683375a0f7e91086e5dac90c5d51bb3f169f75386107a62"

  bottle do
    rebuild 1
    sha256 "42f945d1a62ed5e024729710bfbdc41ec9ad709b8f515e4eb44a149ca7881a6a" => :mojave
    sha256 "37aa92a95adfd6c8b123c225f6ac8cbcbbfd9679a3ffe54f7c873a31ad243057" => :high_sierra
    sha256 "617fe0aab1510cf20c86833db99cade6e626df190b6733eb504c7d4bb4ee07ab" => :sierra
  end

  depends_on "libidn2"
  depends_on "openssl"
  depends_on "readline"

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index aa27abf..d03f56b 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -1849,7 +1849,7 @@ liblftp_jobs_la_SOURCES = Job.cc Job.h CmdExec.cc CmdExec.h\
 liblftp_jobs_la_LIBADD = $(JOB_MODULES_STATIC) liblftp-tasks.la
 lftp_CPPFLAGS = $(AM_CPPFLAGS) $(READLINE_CFLAGS)
 lftp_LDFLAGS = -export-dynamic
-lftp_LDADD = liblftp-jobs.la liblftp-tasks.la $(READLINE_LDFLAGS) $(READLINE_LIBS)
+lftp_LDADD = $(READLINE_LDFLAGS) liblftp-jobs.la liblftp-tasks.la $(READLINE_LIBS)
 lftp_DEPENDENCIES = liblftp-jobs.la
 CLEANFILES = *.la
 AM_CPPFLAGS = -I$(top_srcdir)/lib -I$(top_srcdir)/trio
