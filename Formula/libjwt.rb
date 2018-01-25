class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.9.0.tar.gz"
  sha256 "cc694dfc3abe17d1f5cde4bf6714e39dc17f7cbad352a85ffb0fe6418c584076"
  revision 1

  bottle do
    cellar :any
    sha256 "67026dc6829f12ae607e2eddb78fb999919cebb4d82a31503653e900c2e5deb9" => :high_sierra
    sha256 "df157f3cc1ada89d5e57f630ef1e6e299b61e2f22e6e762dd4bed45485283e4c" => :sierra
    sha256 "7eb5a5b5f8593a2cbbf34740c98fa525b56f65de4fb575062b8975bb0b8a804e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
