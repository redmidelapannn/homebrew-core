class Libsigrokdecode < Formula
  desc "Shared library providing protocol decoding functionality"
  homepage "https://sigrok.org/wiki/Libsigrokdecode"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"

  bottle do
    sha256 "77ba71d57f6bf135d04a323e3189ceeeaf5fe4b2d6ebbc38c46b3ea0c0f2cc2c" => :catalina
    sha256 "9f60ba73d3c7ab7848293ffee0963fa6e88c133faa42fd7378dff6c76c89b0ff" => :mojave
    sha256 "556aeabbe2088319e154dbb45466a93bacc07de7c710b741dd15039c8d27da72" => :high_sierra
  end

  depends_on "gettext" => [:build, :test]
  depends_on "make" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-decoders"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsigrokdecode/libsigrokdecode.h>
      #include <glib.h>

      int main(int argc, char **argv)
      {
        int ret;
        if ((ret = srd_init(NULL)) != SRD_OK) {
          printf("Error initializing libsigrokdecode (%s): %s.",
                  srd_strerror_name(ret), srd_strerror(ret));
          return 1;
        }
        srd_decoder_load_all();
        const GSList* decoders = srd_decoder_list();
        if (!decoders) {
          printf("Error listing decoders");
          return 1;
        };
        guint num_decoders = g_slist_length((GSList *)decoders);
        if (num_decoders == 0) {
          printf("No decoders listed");
          return 1;
        };
        return 0;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs glib-2.0`.chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsigrokdecode",
                   *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
