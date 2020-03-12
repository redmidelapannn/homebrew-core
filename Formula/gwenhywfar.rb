class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/256/gwenhywfar-5.2.0.tar.gz"
  sha256 "ed8e1f81aa32c8c387cccb9d40390db31632be55bc41bd30bc27e3e45d4d2766"

  bottle do
    sha256 "1f488e948ddde2db89087b701da760798ff54e13d80ef6b2a9082895c75e35dc" => :catalina
    sha256 "a46ad7d318311916b0eadeaf8a358894acf61264e775343afbd40b4b4229e4bd" => :mojave
    sha256 "904ef98440a9daa7948c0af7721c81e3b6250b6ad3d9d940bca7cf7da4a36835" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
