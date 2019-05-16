class Libelf < Formula
  desc "ELF object file access library"
  homepage "https://web.archive.org/web/20181111033959/www.mr511.de/software/english.html"
  url "https://web.archive.org/web/20181111033959/www.mr511.de/software/libelf-0.8.13.tar.gz"
  sha256 "591a9b4ec81c1f2042a97aa60564e0cb79d041c52faa7416acb38bc95bd2c76d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "36ea2e91968c07f426ccc318c0a4df72794ddb1de0fd3e42f524908e0e5ee7b7" => :mojave
    sha256 "26a71619db5c29a707a8f362a75c129c68a5b89726f20dbfa6c947061b0f1e81" => :high_sierra
    sha256 "1bf7a962cb5fc5ac6cff2d9afafc5a8c6930b960b7f37183100e3859dee37f49" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compat"
    # Use separate steps; there is a race in the Makefile.
    system "make"
    system "make", "install"
  end

  test do
    elf_content =  "7F454C460101010000000000000000000200030001000000548004083" \
      "4000000000000000000000034002000010000000000000001000000000000000080040" \
      "80080040874000000740000000500000000100000B00431DB43B96980040831D2B20CC" \
      "D8031C040CD8048656C6C6F20776F726C640A"
    File.open(testpath/"elf", "w+b") do |file|
      file.write([elf_content].pack("H*"))
    end

    (testpath/"test.c").write <<~EOS
      #include <gelf.h>
      #include <fcntl.h>
      #include <stdio.h>

      int main(void) {
        GElf_Ehdr ehdr;
        int fd = open("elf", O_RDONLY, 0);
        if (elf_version(EV_CURRENT) == EV_NONE) return 1;
        Elf *e = elf_begin(fd, ELF_C_READ, NULL);
        if (elf_kind(e) != ELF_K_ELF) return 1;
        if (gelf_getehdr(e, &ehdr) == NULL) return 1;
        printf("%d-bit ELF\\n", gelf_getclass(e) == ELFCLASS32 ? 32 : 64);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/libelf",
                   "-lelf", "-o", "test"
    assert_match "32-bit ELF", shell_output("./test")
  end
end
