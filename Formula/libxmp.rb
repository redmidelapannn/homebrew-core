class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.1/libxmp-4.4.1.tar.gz"
  sha256 "353535cc84c8cddae8decec4e65fa4c51fc64f22eb0891bc3dae6eaf25f9cccf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd9ee4ef5121eb895b311edb18ecfce2de735f16ad8d535e31a556c7864c3129" => :sierra
    sha256 "9d3d9d5bde6b5243c5c7ec983daa194b5bd4d2959312cda44f96bffaa50017c4" => :el_capitan
    sha256 "0a855f59c7885c314eadaba88506cd3c55df53bb9492aa13f05792d986ea025b" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/xmp/libxmp.git"
    depends_on "autoconf" => :build
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install resource("demo_mods")
  end

  test do
    test_mod = "#{pkgshare}/give-me-an-om.mod"
    (testpath/"libxmp_test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "xmp.h"

      int main(int argc, char** argv)
      {
          char* mod = argv[1];
          xmp_context context;
          struct xmp_module_info mi;

          context = xmp_create_context();
          if (xmp_load_module(context, mod) != 0) {
              puts("libxmp failed to open module!");
              return 1;
          }

          xmp_get_module_info(context, &mi);
          puts(mi.mod->name);
          return 0;
      }
    EOS

    system ENV.cc, "libxmp_test.c", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("\"#{testpath}/libxmp_test\" #{test_mod}").chomp
  end
end
