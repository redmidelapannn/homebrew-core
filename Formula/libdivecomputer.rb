class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.6.0.tar.gz"
  sha256 "a0fe75b7e5f7d8b73bfe46beb858dde4f5e2b2692d5270c96e69f5cb34aba15a"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3630523c2a7ac2602685c7f31488aa5239a67aa73c91d80e0da6c8a78bb3136b" => :mojave
    sha256 "d4ef1dd52a0e49e8fc7d544f5fa547e084fcc929160570fd1af4a676ad4a90de" => :high_sierra
    sha256 "5a9fbfa40f93743e8ddc68e768ae12eed0fe968564611c19412261cb8c3c0404" => :sierra
    sha256 "c2cebbfb62605e9ddb2f4e214631fc78f7297b557f64f1c341d57c560c0ce788" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdivecomputer/context.h>
      #include <libdivecomputer/descriptor.h>
      #include <libdivecomputer/iterator.h>
      int main(int argc, char *argv[]) {
        dc_iterator_t *iterator;
        dc_descriptor_t *descriptor;
        dc_descriptor_iterator(&iterator);
        while (dc_iterator_next(iterator, &descriptor) == DC_STATUS_SUCCESS)
        {
          dc_descriptor_free(descriptor);
        }
        dc_iterator_free(iterator);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldivecomputer
    ]
    system ENV.cc, "-v", "test.c", "-o", "test", *flags
    system "./test"
  end
end
