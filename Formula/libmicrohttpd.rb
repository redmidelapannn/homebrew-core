class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.70.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.70.tar.gz"
  sha256 "90d0a3d396f96f9bc41eb0f7e8187796049285fabef82604acd4879590977307"

  bottle do
    cellar :any
    sha256 "66ea6a57efdafb8ffa3f3d043b1571dfac5e2dae262afa102d3f2f9e6f277b02" => :catalina
    sha256 "7005919de4fa8e6affe3ade498fc98b964fbd9c6c5ffa82c14555c90c1d4ce4b" => :mojave
    sha256 "920c61fa62c8c30fcbf5af7de3435cc792ed59501b3b03fe4d1b46d119bbaa63" => :high_sierra
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
