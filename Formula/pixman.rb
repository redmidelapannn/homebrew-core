class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"

  bottle do
    cellar :any
    revision 1
    sha256 "fb8e58cbd0423524705d71dad643d039e4cb3c04d9b818f1033224026b166aa8" => :el_capitan
    sha256 "ef689d0d7f58faa4f592a09f3b8faf94ded2886c20d86c1e4ec3312c4189fcb7" => :yosemite
    sha256 "4ec153819157becff9b08a92d1a4d40a682eab7da996014485b4f05fd2050393" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def install
    ENV.universal_binary if build.universal?

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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
