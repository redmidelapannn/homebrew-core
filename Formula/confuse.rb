class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.0/confuse-3.0.tar.xz"
  sha256 "bb75174e02aa8b44fa1a872a47beeea1f5fe715ab669694c97803eb6127cc861"

  bottle do
    cellar :any
    sha256 "e4a88cc66ed0f31e130ff38df173a27bd0e3ff3bfb184390b59eca8d4dbe536b" => :el_capitan
    sha256 "d9c475d08b0092baf8d43b29c2fc09921c797a913559ca555711eb18bdaca0a1" => :yosemite
    sha256 "62a2f1bb643702b765d592b576ac08bfde6761503a124db543b4e25bc67ca9df" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <confuse.h>
      #include <stdio.h>

      cfg_opt_t opts[] =
      {
        CFG_STR("hello", NULL, CFGF_NONE),
        CFG_END()
      };

      int main(void)
      {
        cfg_t *cfg = cfg_init(opts, CFGF_NONE);
        if (cfg_parse_buf(cfg, "hello=world") == CFG_SUCCESS)
          printf("%s\\n", cfg_getstr(cfg, "hello"));
        cfg_free(cfg);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lconfuse", "-o", "test"
    assert_match /world/, shell_output("./test")
  end
end
