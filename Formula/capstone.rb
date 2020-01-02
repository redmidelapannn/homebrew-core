class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/4.0.1.tar.gz"
  sha256 "79bbea8dbe466bd7d051e037db5961fdb34f67c9fac5c3471dd105cfb1e05dc7"
  head "https://github.com/aquynh/capstone.git", :branch => "next"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b1efca71909beec69231367748abe2ef45a40094bd330d95d7cdb114392f97a" => :catalina
    sha256 "ed2a2060236a2264603f645b0349c2da4395fce9fa8e606926a8bb01b98ba321" => :mojave
    sha256 "74b95b246b2574a6241761db118795791d000894b5b3bbc482ee0ce021197f97" => :high_sierra
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
