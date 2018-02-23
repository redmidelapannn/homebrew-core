class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/1.0.1.tar.gz"
  sha256 "3a6a4f2b8c405ab009040ca43af8e4aa10ebe44d9c8b336aa36dc35df955017c"
  head "https://github.com/unicorn-engine/unicorn.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "23de9b41139c8b1cd9590f3a31c2dbee38397865fe01cb90efbc74723e4b1479" => :high_sierra
    sha256 "c05d7ded7fa32bab706d3c723e7042f4e2012e5184f92377a8cee872f52aaaf7" => :sierra
    sha256 "d3762125373503b54c30a582718327821bd752a689273b473d8d3430e99c9835" => :el_capitan
  end

  option "with-all", "Build with support for ARM64, Motorola 64k, PowerPC and "\
    "SPARC"
  option "with-debug", "Create a debug build"
  option "with-test", "Test build"

  depends_on "pkg-config" => :build
  depends_on "cmocka" => :build if build.with? "test"

  def install
    archs  = %w[x86 x86_64 arm mips]
    archs += %w[aarch64 m64k ppc sparc] if build.with?("all")
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = archs.join " "
    ENV["UNICORN_SHARED"] = "yes"
    if build.with?("debug")
      ENV["UNICORN_DEBUG"] = "yes"
    else
      ENV["UNICORN_DEBUG"] = "no"
    end
    system "make"
    system "make", "test" if build.with?("test")
    system "make", "install"
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
  end
end
