class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "97eaef2ab82a46d13ea5e00270712d6475fbe42b"
  version "r2748"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f153adf60e68c7611c6af2a753419320d44e99a62059ef92a96f20913c5684f" => :sierra
    sha256 "fc103a5f13982d4466ff86032733ecf958f5307d0acfe43dd91437263755ea52" => :el_capitan
    sha256 "0f8e9f1e23105bac1dd7c307ce5844b0aef2f68d4a87d1b7fa31d54d1a3fbc79" => :yosemite
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-l-smash", "Build CLI with l-smash mp4 output"

  depends_on "yasm" => :build
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
    (testpath/"test.c").write <<-EOS.undent
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
