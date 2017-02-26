class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  sha256 "54797f6e763d417627f89f60e4ae0a431dab0523f92f83def23ea02d0defafea"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e1f9cd61adc51517c6d4668717e4312ab8c5ee0b58bbc7e125de639f9d9ecdac" => :sierra
    sha256 "0800153292eff3443eb3b87966a6b5be73051e1891182f6fa30d63583a2e0cef" => :el_capitan
    sha256 "13fc435ce4a7fec666556bf0cdc1739b2c594c88f089669cbdde06167f733bff" => :yosemite
  end

  option "with-ssl", "Enable SSL support"

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    # Remove for > 0.9.52
    # Equivalent to upstream commit from 11 Nov 2016 https://gnunet.org/git/libmicrohttpd.git/commit/?id=52e995c0a7741967ab68883a63a8c7e70a4589ee
    # "mhd_itc.c: fixed typo preventing build on Solaris and other systems"
    inreplace "src/microhttpd/mhd_itc.c", "(0 != fcntl (pip.fd[i],",
                                          "(0 != fcntl (itc.fd[i],"

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
