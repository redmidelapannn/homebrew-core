class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  sha256 "96bdab4352a09fd3952a346bc01898536992f50127d0adea1c3096a8ec9f658c"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "015add315caccbee1ae5dd65467f5f7b9de59cb464348eb4a969f9472406446e" => :el_capitan
    sha256 "2d5b728b71806d655d07381895de1906fed7f906cc39c1f08e9f848cafa94c88" => :yosemite
    sha256 "b669a9c6d4d893de102139fdfba76e634411f185bfcb432cfe4df701ee76b9c5" => :mavericks
  end

  option "with-ssl", "Enable SSL support"
  option :universal

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    ENV.universal_binary if build.universal?
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
