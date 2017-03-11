class Libdivecomputer < Formula
  desc "Library for communication with various dive computers."
  homepage "http://www.libdivecomputer.org/"
  url "http://www.libdivecomputer.org/releases/libdivecomputer-0.5.0.tar.gz"
  sha256 "1e0cff7f294e360e142c92c820f9f11cab505fa9385d17713d502cf2f0c5c286"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9300585ba197cba37d3639970a75d6cc1e7e736867b9acaf92f0ac7d3664f7d9" => :sierra
    sha256 "a0b84afb1bd747ed9fc058e16382c7b881c1d03a4dcfaafbfd13a8c1e55d1540" => :el_capitan
    sha256 "20704e860d53f37f784b1cd04cab5474d19513b33abe346707022dc143480ad9" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
