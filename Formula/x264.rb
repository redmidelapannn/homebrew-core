class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git",
      :revision => "e9a5903edf8ca59ef20e6f4894c196f135af735e"
  version "r2854"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "728a6c12bc6e0048f9a6e4b64c833516caf792732b2a3424fa4fd2eb06f16ceb" => :high_sierra
    sha256 "9e617682cb95ec13ae4dd400e3a9cd07fac00126e9d72c5cd7468983865869aa" => :sierra
    sha256 "a5ebce24eefc8809cd4238d82ea16cdf9cdf761a210567325226e60326a73629" => :el_capitan
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-l-smash", "Build CLI with l-smash mp4 output"

  depends_on "nasm" => :build
  depends_on "l-smash" => :optional

  deprecated_option "10-bit" => "with-10-bit"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    args << "--disable-lsmash" if build.without? "l-smash"
    args << "--bit-depth=10" if build.with? "10-bit"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
