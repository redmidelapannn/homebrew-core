class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d0c721d3a2da1a5672d90dbd5f79f5eac597b005877e3b5632f3109089e1b310" => :mojave
    sha256 "c7dc958e30b7045df3be0ef992cd73d20c902960a45fdf317b101460da1bb3ad" => :high_sierra
    sha256 "b1becb6400a22e188bbcfcd40b4a288af02a725cc27a85e505d9f729d3b6a90a" => :sierra
    sha256 "e26f0895080fd52ae004aa2232eb59b7c32d22621d4ec28af5a1f2146112fb48" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
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
