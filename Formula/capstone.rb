class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/3.0.5.tar.gz"
  sha256 "913dd695e7c5a2b972a6f427cb31f2e93677ec1c38f39dda37d18a91c70b6df1"
  head "https://github.com/aquynh/capstone.git"

  depends_on "pkg-config" => :build

  bottle do
    cellar :any
    rebuild 1
    sha256 "61f6c8c8688a1ae2c062b5bbf7de20a133db7bc0e40f8f7748b47883ffb765d6" => :high_sierra
    sha256 "2ed0e27b0c99ec5533e8bfeb7f66ca9b7b1d7b910a50208eaae06c9b31038e9f" => :sierra
    sha256 "fce8236cfc123aeee9268e469a458ec46822d69d5236ea0a59384a0a0dbcf0a2" => :el_capitan
  end

  def install
    ENV["HOMEBREW_CAPSTONE"] = "1"
    ENV["PREFIX"] = prefix
    system "./make.sh"
    system "./make.sh", "install"
  end

  test do
    # code comes from https://www.capstone-engine.org/lang_c.html
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <inttypes.h>
      #include <capstone/capstone.h>
      #define CODE "\\x55\\x48\\x8b\\x05\\xb8\\x13\\x00\\x00"

      int main()
      {
        csh handle;
        cs_insn *insn;
        size_t count;
        if (cs_open(CS_ARCH_X86, CS_MODE_64, &handle) != CS_ERR_OK)
          return -1;
        count = cs_disasm(handle, CODE, sizeof(CODE)-1, 0x1000, 0, &insn);
        if (count > 0) {
          size_t j;
          for (j = 0; j < count; j++) {
            printf("0x%"PRIx64":\\t%s\\t\\t%s\\n", insn[j].address, insn[j].mnemonic,insn[j].op_str);
          }
          cs_free(insn, count);
        } else
          printf("ERROR: Failed to disassemble given code!\\n");
        cs_close(&handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcapstone", "-o", "test"
    system "./test"
  end
end
