class Libsigrokdecode < Formula
  desc "Shared library providing protocol decoding functionality"
  homepage "https://sigrok.org/wiki/Libsigrokdecode"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"

  bottle do
    sha256 "8ea5d5bc1e5a734af9519faa01377a82e019af2446f14273fd301a93d33d4416" => :catalina
    sha256 "87cc8e5de6292a94bb1553c597dff0cf1fbf83c37aa78eaca76f2c15aee1af1d" => :mojave
    sha256 "bcc2526c1b16a9c80b66696dfbb60005837e674c14cf802ff199ed13997041b6" => :high_sierra
  end

  # glib-2.0 >= 2.32.0
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
