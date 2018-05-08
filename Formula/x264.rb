class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://git.videolan.org/git/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://git.videolan.org/git/x264.git",
        :revision => "e9a5903edf8ca59ef20e6f4894c196f135af735e"
    version "r2854"

    # This should probably be removed with the next stable release
    # since HEAD now produces multiple bitdepths at once by default.
    option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "f3bdefbfb56493dae19a7efe52351c12b1652c09129bba590fe4833eba4ac51e" => :high_sierra
    sha256 "a12e7d532d0ce8cfc45caa63c069dc45855c7e02a547b59862532d40f4c40039" => :sierra
    sha256 "d364984a1f8ff9f59e9ade9f8d88a87151ce5e9c3aec4c067b5bf98177d3c65b" => :el_capitan
  end

  depends_on "nasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --enable-shared
      --enable-static
      --enable-strip
    ]
    args << "--bit-depth=10" if build.stable? && build.with?("10-bit")

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
