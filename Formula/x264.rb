class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "97eaef2ab82a46d13ea5e00270712d6475fbe42b"
  version "r2748"
  revision 1
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "9c36a8fd89bdc843e4c490b26eacdfa469c36943dabb5d9845ef334d45e53bc9" => :sierra
    sha256 "187aaba349f80b7157f6547b5635cfe7f1a4a99f53eee405ebe6966be08ab504" => :el_capitan
    sha256 "ad32c53fecc9bc7659e9f6490d73f2846d030006c27490a432bded4df464c709" => :yosemite
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
    args <<  "--extra-cflags=-framework OpenCL"
    args <<  "--extra-ldflags=-framework OpenCL"
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
    system ENV.cc, "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
