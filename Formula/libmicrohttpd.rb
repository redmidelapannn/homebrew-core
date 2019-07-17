class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.65.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.65.tar.gz"
  sha256 "f2467959c5dd5f7fdf8da8d260286e7be914d18c99b898e22a70dafd2237b3c9"

  bottle do
    cellar :any
    sha256 "396a2ec2a0ea1663af33f796628560825ccf8fcb17b8f02494a7bf4683b8a8a1" => :mojave
    sha256 "402ef3660e70681fdc4da5726b8c31f2c71fdddae1aa19540338f0052901a55d" => :high_sierra
    sha256 "0d07a894dad72d323e09ef3c0c880a1ad15ff6f5fccc2f40a81a0f955c203167" => :sierra
  end

  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/examples"
  end

  test do
    cp pkgshare/"examples/simplepost.c", testpath
    inreplace "simplepost.c",
      "return 0",
      "printf(\"daemon %p\", daemon) ; return 0"
    system ENV.cc, "-o", "foo", "simplepost.c", "-I#{include}", "-L#{lib}", "-lmicrohttpd"
    assert_match /daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo")
  end
end
