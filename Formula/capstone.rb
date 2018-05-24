class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://www.capstone-engine.org/download/3.0.4/capstone-3.0.4.tgz"
  sha256 "3e88abdf6899d11897f2e064619edcc731cc8e97e9d4db86495702551bb3ae7f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a37e05ac366e4ddc4d9dedf48214cc0846356c27281c210cf55305508fae704f" => :high_sierra
    sha256 "0958666d426b7017735a90d3b08d3163fb2343fc8bf1e2460456871fa64be349" => :sierra
    sha256 "18e95587b2986cf720ae4327788391c4fce88f7c68f0629c58d9dd32459c1a6d" => :el_capitan
  end

  head do
    url "https://github.com/aquynh/capstone.git"

    depends_on "pkg-config" => :build
  end

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
