class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz"
  sha256 "cfafd339ccd9c5ef8d6ab15d7e1a412c054bf4cb4ecbbbcc78c12ef2def70732"

  bottle do
    cellar :any
    rebuild 1
    sha256 "494e4277440ed26ad11e836a546a0897851ac875df73d1c4590db1c98cbed3f4" => :sierra
    sha256 "4248722d8fb5d3a9b4608773251d0a1a56bf67a3091d1df2c8b058c4aab3502b" => :el_capitan
    sha256 "a8ab6547305615bb97174707f4650a7513266eec75e2287691f9b9a58c19cabb" => :yosemite
  end

  head do
    url "https://git.xiph.org/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-custom-modes", "Enable custom-modes for opus see https://www.opus-codec.org/docs/opus_api-1.1.3/group__opus__custom.html"

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <opus.h>

      int main(int argc, char **argv)
      {
        int err = 0;
        opus_int32 rate = 48000;
        int channels = 2;
        int app = OPUS_APPLICATION_AUDIO;
        OpusEncoder *enc;
        int ret;

        enc = opus_encoder_create(rate, channels, app, &err);
        if (!(err < 0))
        {
          err = opus_encoder_ctl(enc, OPUS_SET_BITRATE(OPUS_AUTO));
          if (!(err < 0))
          {
             opus_encoder_destroy(enc);
             return 0;
          }
        }
        return err;
      }
    EOS
    system ENV.cxx, "-I#{include}/opus", "-L#{lib}", "-lopus",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
