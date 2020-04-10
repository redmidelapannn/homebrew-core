class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/1.0.1.tar.gz"
  sha256 "3a6a4f2b8c405ab009040ca43af8e4aa10ebe44d9c8b336aa36dc35df955017c"
  head "https://github.com/unicorn-engine/unicorn.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8666ef12475ec4c5d5cbe71f130a86bd04fd43b3e4a505ca61ba9a4c148d7f40" => :catalina
    sha256 "069bc31be3256b687e3b730da4d0fbe415c2049251c0a53ec5a8fceef4209cc3" => :mojave
    sha256 "fffa6ee83889b623fd5d75358d67b20df6ee3984472132cf4bc88f1ae1ad4f6e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos # Due to Python 2 (Might work with Python 3 with next release (1.0.2)
  # See https://github.com/Homebrew/linuxbrew-core/pull/19728

  def install
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = "x86 x86_64 arm mips aarch64 m64k ppc sparc"
    ENV["UNICORN_SHARED"] = "yes"
    ENV["UNICORN_DEBUG"] = "no"
    system "make"
    system "make", "install"

    cd "bindings/python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test1.c").write <<~EOS
      /* Adapted from https://www.unicorn-engine.org/docs/tutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder
       * assertion that the libraries are intact and available.
       */

      #include <stdio.h>

      #include <unicorn/unicorn.h>

      #define X86_CODE32 "\x41\x4a"
      #define ADDRESS 0x1000000

      int main(int argc, char *argv[]) {
        uc_engine *uc;
        uc_err err;
        int r_ecx = 0x1234;
        int r_edx = 0x7890;

        err = uc_open(UC_ARCH_X86, UC_MODE_32, &uc);
        if (err != UC_ERR_OK) {
          fprintf(stderr, "Failed on uc_open() with error %u.\\n", err);
          return -1;
        }
        uc_mem_map(uc, ADDRESS, 2 * 1024 * 1024, UC_PROT_ALL);
        if (uc_mem_write(uc, ADDRESS, X86_CODE32, sizeof(X86_CODE32) - 1)) {
          fputs("Failed to write emulation code to memory.\\n", stderr);
          return -1;
        }
        uc_reg_write(uc, UC_X86_REG_ECX, &r_ecx);
        uc_reg_write(uc, UC_X86_REG_EDX, &r_edx);
        err = uc_emu_start(uc, ADDRESS, ADDRESS + sizeof(X86_CODE32) - 1, 0, 0);
        if (err) {
          fprintf(stderr, "Failed on uc_emu_start with error %u (%s).\\n",
            err, uc_strerror(err));
          return -1;
        }
        uc_close(uc);
        puts("Emulation complete.");
        return 0;
      }
    EOS
    system ENV.cc, "-o", testpath/"test1", testpath/"test1.c",
      "-lpthread", "-lm", "-L#{lib}", "-lunicorn"
    system testpath/"test1"

    system "python", "-c", "import unicorn; print(unicorn.__version__)"
  end
end
