class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.64.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.64.tar.gz"
  sha256 "e792d8ed5990823a0baadea0adf94365999e702f6f1314ef9c555018dafc350e"

  bottle do
    cellar :any
    sha256 "ff04aa8e8395175d85f334df1046680f523970e0ae28aff6b5eaf52541be8c52" => :mojave
    sha256 "b08215358e7e8e5f241ca37af69ac1e66805601ba590bab2be3d754b5eb4e698" => :high_sierra
    sha256 "53901f86c0cbbc011e4999a3ab867e1b765cb2d5527638e09d122f381815d6f8" => :sierra
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
