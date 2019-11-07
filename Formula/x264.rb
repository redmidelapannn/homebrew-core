class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  revision 1
  head "https://git.videolan.org/git/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://git.videolan.org/git/x264.git",
        :revision => "0a84d986e7020f8344f00752e3600b9769cc1e85"
    version "r2917"
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "6ba8abc14a40e819f765c3d28598e03d030577e27ddc74c4a5cf4d7cbd4098a2" => :catalina
    sha256 "faf6091d6c714d8ad1df90bda42cc9107a85a8a2cec7ba3f21e9af07d1ed897c" => :mojave
    sha256 "0d510c7ccc6f4757502bd8888c5ddbba3668ef810e48b35aaedd5128938534cf" => :high_sierra
  end

  depends_on "nasm" => :build

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

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
