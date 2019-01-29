class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "https://fallabs.com/kyototycoon/"
  url "https://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  revision 2

  bottle do
    rebuild 1
    sha256 "ed6f745f07b72688f65d6ced8382cfcb13bc5d56f9226811d2ac9035e2c3c882" => :mojave
    sha256 "71046c9be40736c056aee80d2d28876e94fee6ea9e3419c6af5b3792c127b362" => :high_sierra
    sha256 "e8bdb6d26463ae289c035f71dbe44989888a69a6d910dc729b2c1d0108af26ba" => :sierra
  end

  depends_on "kyoto-cabinet"
  depends_on "lua"

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-kc=#{Formula["kyoto-cabinet"].opt_prefix}",
                          "--with-lua=#{Formula["lua"].opt_prefix}"
    system "make"
    system "make", "install"
  end
end


__END__
--- a/ktdbext.h  2013-11-08 09:34:53.000000000 -0500
+++ b/ktdbext.h  2013-11-08 09:35:00.000000000 -0500
@@ -271,7 +271,7 @@
       if (!logf("prepare", "started to open temporary databases under %s", tmppath.c_str()))
         err = true;
       stime = kc::time();
-      uint32_t pid = getpid() & kc::UINT16MAX;
+      uint32_t pid = kc::getpid() & kc::UINT16MAX;
       uint32_t tid = kc::Thread::hash() & kc::UINT16MAX;
       uint32_t ts = kc::time() * 1000;
       for (size_t i = 0; i < dbnum_; i++) {
