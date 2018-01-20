class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.6.0.tar.gz"
  sha256 "a0fe75b7e5f7d8b73bfe46beb858dde4f5e2b2692d5270c96e69f5cb34aba15a"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c9c7bfe4a0a60f27312cb26403beb789ed046f50c43dd8f0c9c8c999f7c7c2b1" => :high_sierra
    sha256 "0654e597ada55e438024b5c8429240b05a8a87b56ef2e02dbc8029c5cbd51943" => :sierra
    sha256 "fd53c81c969d6733f3cda3dba69d13943e9f2d85d95528ceac89b461d55ef0f8" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb" => :recommended

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
