class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "14fb9460ad163674f0a4ecbc9b6ba7ef2b784099fefb7545f9cdfb017711f36c" => :high_sierra
    sha256 "8d20fd2aef6b6d248251c281924038013b9d49e356c2d73bd3de1f315c43f7f5" => :sierra
    sha256 "9ae01fed6094143642a65c24c1c97b3ad5ceed030dafc00cac0761908811c5ae" => :el_capitan
  end

  depends_on "pkg-config" => :build

  # Fix "error: use of unknown builtin '__builtin_shuffle'"
  # Upstream issue 31 Jan 2018 "Fails to build pixman-0.34.0 with clang 5.x or later"
  # See https://bugs.freedesktop.org/show_bug.cgi?id=104886
  if DevelopmentTools.clang_build_version >= 902
    patch do
      url "https://bugs.freedesktop.org/attachment.cgi?id=137100"
      sha256 "2af5b3700e38600297f2cb66059218b1128337d995cba799b385ad09942c934f"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
