class Glkterm < Formula
  desc "Terminal-window Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glkterm-104.tar.gz"
  version "1.0.4"
  sha256 "473d6ef74defdacade2ef0c3f26644383e8f73b4f1b348e37a9bb669a94d927e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "263b8b13164b67492bdd0230bfa9324ead0f356d4c1db6a791c40fd28fc32395" => :high_sierra
    sha256 "2329df4e1c269fae84bded1fb374abe0b28fe2d78c9ecf29debeb342641ec5b7" => :sierra
    sha256 "593fac2bbb30fe1e9ca9e67572e142dd4744c05b58b7902a443e88b0d85fec16" => :el_capitan
  end

  keg_only "conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libglkterm.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glkterm"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "glk.h"
      #include "glkstart.h"

      glkunix_argumentlist_t glkunix_arguments[] = {
          { NULL, glkunix_arg_End, NULL }
      };

      int glkunix_startup_code(glkunix_startup_t *data)
      {
          return TRUE;
      }

      void glk_main()
      {
          glk_exit();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglkterm", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
