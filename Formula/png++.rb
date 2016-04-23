class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "http://www.nongnu.org/pngpp/"
  url "https://savannah.nongnu.org/download/pngpp/png++-0.2.9.tar.gz"
  sha256 "abbc6a0565122b6c402d61743451830b4faee6ece454601c5711e1c1b4238791"
  head "svn://svn.savannah.nongnu.org/pngpp/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "d90191b266e39eee92a4a6c37b822ce3ecbeb090df4b91b2812339f69c1304d2" => :el_capitan
    sha256 "dbb74dfcf5b27cc46d03dec9c6aac2fa20f6ef51b9d28fd45a5ed8b7423c35dd" => :yosemite
    sha256 "0cda937f9a2da2b9e84a46fc9c28f6b0e3082bbbe7e7315475ef1c328f658043" => :mavericks
  end

  depends_on "libpng"

  # Fix strerror_r usage for OS X clang
  # patch from <https://savannah.nongnu.org/bugs/?46312>
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOF.undent
      #include <png++/png.hpp>
      #include <iostream>

      int main(int argc, char **argv) {
        try {
          png::image<png::rgb_pixel> image(argv[1]);
          png::rgb_pixel const pixel = image.get_pixel(0, 0);
          if (pixel.red != 0x00 || pixel.green != 0x00 || pixel.blue != 0xFF) {
            return 1;
          }
        } catch(png::error &e) {
          std::cerr << e.what() << std::endl;
          throw;
        }
        return 0;
      }
    EOF

    system ENV.cxx, "test.cc", "-I#{include}", "-I#{Formula["libpng"].include}", "-L#{Formula["libpng"].lib}", "-lpng", "-o", "test"
    system "./test", test_fixtures("test.png")
  end
end

__END__
--- a/error.hpp
+++ b/error.hpp
@@ -93,20 +93,15 @@ namespace png
     protected:
         static std::string thread_safe_strerror(int errnum)
         {
-#define ERRBUF_SIZE 512
+#define ERRBUF_SIZE 8192
             char buf[ERRBUF_SIZE] = { 0 };
 
 #ifdef HAVE_STRERROR_S
             strerror_s(buf, ERRBUF_SIZE, errnum);
             return std::string(buf);
 #else
-#if (_POSIX_C_SOURCE >= 200112L || _XOPEN_SOURCE >= 600) && !_GNU_SOURCE
             strerror_r(errnum, buf, ERRBUF_SIZE);
             return std::string(buf);
-#else
-            /* GNU variant can return a pointer to static buffer instead of buf */
-            return std::string(strerror_r(errnum, buf, ERRBUF_SIZE));
-#endif
 #endif
 
 #undef ERRBUF_SIZE
