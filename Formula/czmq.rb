class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.0.2/czmq-4.0.2.tar.gz"
  sha256 "808c7a2262ca733d7a2c362e0a00fdbe5ec517d90fa017ba405b7cdb4f81eb89"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6e0804a5e0d397bbed231c490865afe9a34e7162ce9c0bd94756ee92eee349c" => :sierra
    sha256 "8006c6edce81f788b342c518fe8809bfb7ac564b88d45afdc491e610723f8711" => :el_capitan
    sha256 "a9c0321b76248070ebfab73967143187f688eb5a80ba37e042a5a6db4951e04a" => :yosemite
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-drafts", "Build and install draft classes and methods"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "zeromq"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-drafts" if build.with? "drafts"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "ZSYS_INTERFACE=lo0", "check-verbose"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <czmq.h>

      int main(void)
      {
        zsock_t *push = zsock_new_push("inproc://hello-world");
        zsock_t *pull = zsock_new_pull("inproc://hello-world");

        zstr_send(push, "Hello, World!");
        char *string = zstr_recv(pull);
        puts(string);
        zstr_free(&string);

        zsock_destroy(&pull);
        zsock_destroy(&push);

        return 0;
      }
    EOS

    flags = ENV.cflags.to_s.split + %W[
      -I#{include}
      -L#{lib}
      -lczmq
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    assert_equal "Hello, World!\n", shell_output("./test")
  end
end
