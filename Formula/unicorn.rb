class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/1.0.1.tar.gz"
  sha256 "3a6a4f2b8c405ab009040ca43af8e4aa10ebe44d9c8b336aa36dc35df955017c"
  head "https://github.com/unicorn-engine/unicorn.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "5bb5f664d150e61e4e51cd72869bf041def73cfd35f2e3db33887ab5f6a656cb" => :catalina
    sha256 "d41fbd51a755e5959f7d8b647a4e17eeb057e7480853a1f68254ca813f26e5b7" => :mojave
    sha256 "cb70f50f6aa72a2cdfec2e2ffd1ab1a9e5367cebb3d25044cf949275230f7c73" => :high_sierra
  end

  depends_on "pkg-config" => :build

  # See https://github.com/Homebrew/linuxbrew-core/pull/19728
  # Might work with Python 3 starting with next release (1.0.2)
  uses_from_macos "python@2" # Does not work with Python 3

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
