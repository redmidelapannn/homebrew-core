class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.66.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.66.tar.gz"
  sha256 "4e66d4db1574f4912fbd2690d10d227cc9cc56df6a10aa8f4fc2da75cea7ab1b"

  bottle do
    cellar :any
    sha256 "61c247d5da747c0d53edd9ae57ca678748a70baeed0f8a0f101695e411652a4b" => :mojave
    sha256 "9ae32eb6c37a71800a1a4b0be54b2bd6e8cf5c87ed16eb88909a1eb6e9647472" => :high_sierra
    sha256 "13d9c59bd52f3312e2489085328a39b077144d71f21c181972590da74717b8d6" => :sierra
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
