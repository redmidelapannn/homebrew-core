class Libsigrok < Formula
  desc "Shared library of drivers for logic analyzers and input/output files"
  homepage "https://sigrok.org/wiki/Libsigrok"
  url "https://sigrok.org/download/source/libsigrok/libsigrok-0.5.2.tar.gz"
  sha256 "4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c"

  bottle do
    cellar :any
    sha256 "0996448743205339d130add73dbb878ed57d5993d8517054a5fd3d242103231c" => :catalina
    sha256 "e962eb354ca39a370ba689ec1b956da899b5b26c8852a0f8b196805bea5eb0b4" => :mojave
    sha256 "d59d264ecb06f016b238af0b2188ddc7b066f312523e53fd09bd74eacc77ba2d" => :high_sierra
  end

  depends_on "doxygen" => :build
  depends_on "make" => :build
  depends_on "gettext" => [:buld, :test]
  depends_on "pkg-config" => [:buld, :test]
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libftdi"
  depends_on "libserialport"
  depends_on "libusb"
  depends_on "libzip"
  depends_on "sigrok-firmware-fx2lafw"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsigrok/libsigrok.h>

      int main(int argc, char **argv)
      {
        int ret;
        struct sr_context *sr_ctx;
        if ((ret = sr_init(&sr_ctx)) != SR_OK) {
                printf("Error initializing libsigrok (%s): %s.",
                        sr_strerror_name(ret), sr_strerror(ret));
                return 1;
        }
        // Use libsigrok functions here...
        if ((ret = sr_exit(sr_ctx)) != SR_OK) {
                printf("Error shutting down libsigrok (%s): %s.",
                        sr_strerror_name(ret), sr_strerror(ret));
                return 1;
        }
        return 0;
      }
    EOS
    pkg_config_flags = `(pkg-config --cflags glib-2.0)`.chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsigrok",
                   *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
