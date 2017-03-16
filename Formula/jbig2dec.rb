class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.12.tar.gz"
  sha256 "bcc5f2cc75ee46e9a2c3c68d4a1b740280c772062579a5d0ceda24bee2e5ebf0"

  bottle do
    cellar :any
    rebuild 2
    sha256 "112deaf005a42be72ce271976d267974b01623d3f5c5050bc3f0056a51abb31a" => :sierra
    sha256 "da4be1d5f1821e98adfacf9cd2f8d86b16c2e288b042b38d1a5be9374279b35b" => :el_capitan
    sha256 "040d1be421eb9f61adb1959e0511a4280fee26893296cf6cdfa2e28fe0d69313" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "libpng" => :optional

  # https://bugs.ghostscript.com/show_bug.cgi?id=695890
  # Remove on next release.
  patch do
    # Original URL: https://git.ghostscript.com/?p=jbig2dec.git;a=commitdiff_plain;h=70c7f1967f43a94f9f0d6808d6ab5700a120d2fc
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7dc28b82/jbig2dec/bug-695890.patch"
    sha256 "5239e4eb991f198d2ba30d08011c2887599b5cead9db8b1d3eacec4b8912c2d0"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    args << "--without-libpng" if build.without? "libpng"

    system "autoreconf", "-fvi" # error: cannot find install-sh
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdint.h>
      #include <stdlib.h>
      #include <jbig2.h>

      int main()
      {
        Jbig2Ctx *ctx;
        Jbig2Image *image;
        ctx = jbig2_ctx_new(NULL, 0, NULL, NULL, NULL);
        image = jbig2_image_new(ctx, 10, 10);
        jbig2_image_release(ctx, image);
        jbig2_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-DJBIG_NO_MEMENTO", "-L#{lib}", "-ljbig2dec", "-o", "test"
    system "./test"
  end
end
