class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d060c364f764181fb22f1c1c2de06f0c30723e5ab225ea8d8446eefe5ded371" => :sierra
    sha256 "d6f743326c540f06826ee6035f33ac7fa09e4e41a15bc05d61bb070532145e42" => :el_capitan
    sha256 "72e2a02a1a6da823bfee8579c134ce639894bd85457f16885692fd3dc65b858b" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-mmx", # MMX assembler fails with Xcode 7
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
