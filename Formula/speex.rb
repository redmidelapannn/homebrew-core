class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    rebuild 1
    sha256 "46ceff1405600078b9959d5b95c3c079cb90dc59eae055a9c44eb61ea3c4eab7" => :high_sierra
    sha256 "1939e116d75f2bed2f95aae36141665a96597c0a97d599f7ae6e6088f9146e09" => :sierra
    sha256 "5efdd2c766b89b274e4c99d256d45466db84e366f028cd112f15a6aaa1a169ce" => :el_capitan
  end

  option "with-sse", "Build with SSE support"

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "speexdsp" => :optional

  def install
    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    args << "--enable-sse" if build.with? "sse"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <speex/speex.h>

      int main()
      {
          SpeexBits bits;
          void *enc_state;

          speex_bits_init(&bits);
          enc_state = speex_encoder_init(&speex_nb_mode);

          speex_bits_destroy(&bits);
          speex_encoder_destroy(enc_state);

          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lspeex", "test.c", "-o", "test"
    system "./test"
  end
end
