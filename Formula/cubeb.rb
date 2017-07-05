class Cubeb < Formula
  desc "Cross-platform audio library."
  homepage "https://github.com/kinetiknz/cubeb"
  url "https://github.com/kinetiknz/cubeb/archive/cubeb-0.2.tar.gz"
  sha256 "cac10876da4fa3b3d2879e0c658d09e8a258734562198301d99c1e8228e66907"

  head "https://github.com/kinetiknz/cubeb.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "858540fbe98a45e468537d36517e96b01f327c396253bd956a97f170e6f99029" => :sierra
    sha256 "0073eb0f13d14dc3fa5a6ff9b935b5448e432c7eb108a6fd33120b8a3474c0ae" => :el_capitan
    sha256 "dc4c18b53d81ad727b9c7e4d11dfc360bc668fef4646d36fe0976d06915c4647" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <cubeb/cubeb.h>

      #define TEST(test, msg) \
        if ((test)) { \
          printf("PASS: %s\\n", msg); \
        } else { \
          printf("FAIL: %s\\n", msg); \
          goto end; \
        }

      /* Dummy callbacks to use for audio stream test */
      static long data_callback(cubeb_stream *stream, void *user, void *buffer,
          long nframes) {
        return nframes;
      }
      static void state_callback(cubeb_stream *stream, void *user_ptr,
          cubeb_state state) {}

      int main() {
        int ret;
        cubeb *ctx;
        char const *backend_id;
        cubeb_stream *stream;
        cubeb_stream_params params;

        /* Verify that the library initialises itself successfully */
        ret = cubeb_init(&ctx, "test_context");
        TEST(ret == CUBEB_OK, "initialse cubeb context");

        /* Verify backend id can be retrieved */
        backend_id = cubeb_get_backend_id(ctx);
        TEST(backend_id != NULL, "retrieve backend id");

        /* Verify that an audio stream gets opened successfully */
        params.format = CUBEB_SAMPLE_S16LE; /* use commonly supported      */
        params.rate = 48000;                /* parametrs, so that the test */
        params.channels = 1;                /* doesn't give a false fail   */
        ret = cubeb_stream_init(ctx, &stream, "test_stream", params, 100,
          data_callback, state_callback, NULL);
        TEST(ret == CUBEB_OK, "initialise stream");

      end:
        /* Cleanup and return */
        cubeb_stream_destroy(stream);
        cubeb_destroy(ctx);
        return 0;
      }
    EOS
    system "cc", "-o", "test", "#{testpath}/test.c", "-L#{lib}", "-lcubeb"
    assert_no_match(/FAIL:.*/, shell_output("#{testpath}/test"),
                    "Basic sanity test failed.")
  end
end
