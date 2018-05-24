class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://www.capstone-engine.org/download/3.0.4/capstone-3.0.4.tgz"
  sha256 "3e88abdf6899d11897f2e064619edcc731cc8e97e9d4db86495702551bb3ae7f"
  head "https://github.com/aquynh/capstone.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c8f21d476b2966ea2942e306f843760c37956bb0ed968df578021bcff849518d" => :high_sierra
    sha256 "ee1df1070e95a189d7cde85456932226076f4adebd57719e042789749dafb7a5" => :sierra
    sha256 "69adfe37a098117f4a7d526686cd821627f290ac77f358ec81f974a6d5bcf196" => :el_capitan
  end

  depends_on "pkg-config" => :build if build.head?

  def install
    if build.head?
      ENV["PREFIX"] = prefix
    else
      # Capstone's Make script ignores the prefix env and was installing
      # in /usr/local directly. So just inreplace the prefix for less pain.
      # https://github.com/aquynh/capstone/issues/228
      inreplace "make.sh", "export PREFIX=/usr/local", "export PREFIX=#{prefix}"
    end

    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"

    unless build.head?
      # As per the above inreplace, the pkgconfig file needs fixing as well.
      inreplace lib/"pkgconfig/capstone.pc" do |s|
        s.gsub! "/usr/lib", lib
        s.gsub! "/usr/include/capstone", "#{include}/capstone"
      end
    end
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
