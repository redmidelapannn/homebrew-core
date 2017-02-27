class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  sha256 "54797f6e763d417627f89f60e4ae0a431dab0523f92f83def23ea02d0defafea"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c43dfffbe57f1cb38c813584294063e2f46c090ac448523ad6e664d84a991797" => :sierra
    sha256 "1c790a2f42c34ac19d4a5aff84101c85e314e56624b181458326966804436c02" => :el_capitan
    sha256 "28470e359503ac2dd50e6a73026e3c1ab0590d742107450325f58a727b4b4076" => :yosemite
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
