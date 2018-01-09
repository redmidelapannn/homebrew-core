class Splint < Formula
  desc "Secure Programming Lint"
  homepage "https://www.freshports.org/devel/splint/"
  url "https://ftp.mirrorservice.org/sites/ftp.wiretapped.net/pub/security/development/auditing/splint/splint-3.1.2.src.tgz"
  mirror "https://fossies.org/linux/misc/old/splint-3.1.2.src.tgz/"
  sha256 "c78db643df663313e3fa9d565118391825dd937617819c6efc7966cdf444fb0a"

  bottle do
    rebuild 1
    sha256 "ff38abf1f9964ebec5bb8b31c4dc8c2b085aec3a4e1b0b7bf0739b5d285326b3" => :high_sierra
    sha256 "aee9be58e8321179562ff1dc13d3f330fe47d114b02a469687aa64f6ac4e8250" => :sierra
    sha256 "dc217c273f90b55a6d9299006159d2b296d7079023a22bb897a0c909abb3cace" => :el_capitan
  end

  # fix compiling error of osd.c
  patch :DATA

  def install
    ENV.deparallelize # build is not parallel-safe
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.c"
    path.write <<~EOS
      #include <stdio.h>
      int main()
      {
          char c;
          printf("%c", c);
          return 0;
      }
    EOS

    output = shell_output("#{bin}/splint #{path} 2>&1", 1)
    assert_match "5:18: Variable c used before definition", output
  end
end


__END__
diff --git a/src/osd.c b/src/osd.c
index ebe214a..4ba81d5 100644
--- a/src/osd.c
+++ b/src/osd.c
@@ -516,7 +516,7 @@ osd_getPid ()
 # if defined (WIN32) || defined (OS2) && defined (__IBMC__)
   int pid = _getpid ();
 # else
-  __pid_t pid = getpid ();
+  pid_t pid = getpid ();
 # endif

   return (int) pid;
