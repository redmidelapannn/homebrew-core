class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"

  bottle do
    cellar :any
    revision 1
    sha256 "09ecf9505b184d44740f6f0fbc2fe67427704fffb928f45b4783416340c01f43" => :el_capitan
    sha256 "6f2f5e054b09121554e6a7234291be996a743d23747844562a3df04b120ebfdc" => :yosemite
    sha256 "860adcdd134d8bf42c64f64b0066823a33ea2148cd68d918a549c7e503a9e078" => :mavericks
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
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
