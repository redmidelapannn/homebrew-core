class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.2/confuse-3.2.tar.xz"
  sha256 "a46abb8696026d314197b6a70ae1a1c296342a9a68aa69b1935709c1477a4e48"

  bottle do
    cellar :any
    rebuild 1
    sha256 "321ea234a06443418fac4ad1952b4dc01be4e83136d69a3852c6251399ec9a9f" => :sierra
    sha256 "edea6d044692a2a8afcc256fdda5ac44a63977436019660cbe709a96980b0e1d" => :el_capitan
    sha256 "d3a52cf0c806bc155f18eefb48a1edef4d7ff1e2b2be5a263c34611e2179ef66" => :yosemite
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
    system ENV.cc, "test.c", "-L#{lib}", "-lconfuse", "-o", "test"
    assert_match /world/, shell_output("./test")
  end
end
