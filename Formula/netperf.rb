class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"
  url "https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz"
  sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"
  head "https://github.com/HewlettPackard/netperf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ce53a4bd4b180b52421b7e1d8226a92ddd8ac1cebb8186c0bafb90ca6531f7ff" => :high_sierra
    sha256 "07a2f89374c745d02dc49df9760da13ab53b10c12c23a9780612ef9c95a92fcf" => :sierra
    sha256 "2bbbf61286858bef63cc48365a7138770af1512cda158c8b3274e7f465188ee1" => :el_capitan
  end

  # We need the patch to build with demo mode on OSX. This is already fixed in
  # upstream git, but no release has been made since.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-demo",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end

__END__
--- a/src/netlib.c	2015-07-20 18:39:35.000000000 +0100
+++ a/src/netlib.c	2016-02-08 11:34:16.000000000 +0000
@@ -4000,7 +4000,7 @@
 #ifdef WIN32
 __forceinline void demo_interval_display(double actual_interval)
 #else
-  inline void demo_interval_display(double actual_interval)
+  void demo_interval_display(double actual_interval)
 #endif
 {
   static int count = 0;
@@ -4067,7 +4067,7 @@
    inline directive has to appear in netlib.h... */
 void demo_interval_tick(uint32_t units)
 #else
-  inline void demo_interval_tick(uint32_t units)
+  void demo_interval_tick(uint32_t units)
 #endif
 {
   double actual_interval = 0.0;
