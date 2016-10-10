class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=201&file=01&dummy=gwenhywfar-4.15.3.tar.gz"
  sha256 "6a0e8787c99620414da6140e567c616b55856c5edf8825a9ebc67431923ee63a"

  head "http://git.aqbanking.de/git/gwenhywfar.git"

  bottle do
    rebuild 1
    sha256 "34821374c6f92f7c774f886ebec22c9306da702066fef403b70d184a15e2ecd6" => :sierra
    sha256 "2f0c9860c6abca63e43631e72bd2950bd17b44a5ad0ed22aee40c78102c7dd28" => :el_capitan
    sha256 "63f9484c3d08ea3934b45df7e24b64ab6ee11fdb9dd97913d53534526efb8601" => :yosemite
  end

  option "without-cocoa", "Build without cocoa support"
  option "with-test", "Run build-time check"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "libgcrypt"
  depends_on "gtk+" => :optional

  def install
    guis = []
    guis << "gtk2" if build.with? "gtk+"
    guis << "cocoa" if build.with? "cocoa"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
