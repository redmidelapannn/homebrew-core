class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.0.0/czmq-4.0.0.tar.gz"
  sha256 "9b9d0686fd9a7bdf67c381229c3743cafa94971606d9984fd7f8c4df1fd56fad"

  bottle do
    cellar :any
    sha256 "5f8367042a3c5ef7aa15a61dc1843e5b480fca4a84ca211dd531166edc3717ad" => :sierra
    sha256 "2961e967af3133d1f4637ca073f86adbc4c391225b296ab9d6c2088f76cb13ff" => :el_capitan
    sha256 "19ddf6c12e5896d947083af4d56dd055c9ed8d3630a7a0a49086ce2b0dcab0be" => :yosemite
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libsodium" => :recommended

  conflicts_with "mono", :because => "both install `makecert` binaries"

  if build.without? "libsodium"
    depends_on "zeromq" => "without-libsodium"
  else
    depends_on "zeromq"
  end

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-libsodium" if build.with? "libsodium"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "(ZSYS_INTERFACE=lo0 && make check-verbose)"
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
