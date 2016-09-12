class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"

  stable do
    url "https://libssh2.org/download/libssh2-1.7.0.tar.gz"
    sha256 "e4561fd43a50539a8c2ceb37841691baf03ecb7daf043766da1b112e4280d584"

    depends_on "openssl" => :recommended
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "57ea99afd0800e66b0ab0fcfe7cc3edba2eca23831784aeed0c8185e21ab53ce" => :el_capitan
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "openssl@1.1" => :recommended
  end

  option "with-libressl", "build with LibreSSL instead of OpenSSL"

  depends_on "libressl" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      openssl = build.head? ? Formula["openssl@1.1"] : Formula["openssl"]
      args << "--with-libssl-prefix=#{openssl.opt_prefix}"
    end

    system "./buildconf" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
