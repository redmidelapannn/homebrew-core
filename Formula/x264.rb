class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git",
      :revision => "aaa9aa83a111ed6f1db253d5afa91c5fc844583f"
  version "r2795"
  revision 1
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "12be31c64f090488a744f701d7eef5b7c2b8370706c3b255fdf9d0c126a670fb" => :high_sierra
    sha256 "036497460a7fde91dc78bb59aade2648adf641ffa97e3e7ef4662aa46c8648ed" => :sierra
    sha256 "7b9ad0d0094e9b041a69163f1265e48d40ca6cdd9255cdeba8c71b1a57c35628" => :el_capitan
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-l-smash", "Build CLI with l-smash mp4 output"

  depends_on "yasm" => :build
  depends_on "l-smash" => :optional

  deprecated_option "10-bit" => "with-10-bit"

  def install
    # "--disable-avs" is needed. See https://github.com/Homebrew/homebrew-core/issues/20172
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
      --disable-avs
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
