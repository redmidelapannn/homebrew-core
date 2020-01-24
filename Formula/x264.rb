class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        :revision => "1771b556ee45207f8711744ccbd5d42a3949b14c"
    version "r2991"
  end

  bottle do
    cellar :any
    sha256 "1881db48a5598115d4ddcd04ee2a670682eeba05aa4623827e2e851fed89d0f4" => :catalina
    sha256 "070aef6f57c7b39c9f1ebcdd087855aa97ea829abb2a955d71e6f8c269b0270c" => :mojave
    sha256 "7e5d8df810bab9ec548b101d18b967f37a40898ed7104751d8ec22d954d02284" => :high_sierra
  end

  depends_on "nasm" => :build

  def install
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
