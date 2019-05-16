class Libelf < Formula
  desc "ELF object file access library"
  homepage "https://github.com/WolfgangSt/libelf"
  url "https://github.com/WolfgangSt/libelf.git",
      :revision => "dbbf0eddb1f7d243f5f909cba13597ad76fc4fcb"
  version "0.8.12"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3300c5449b62b1c68c1d0e4a7b05e093e6e0614f6e539cb1e100672908626b9" => :mojave
    sha256 "8d7c8795ca3f253e157990ceb7a9f260d16c4a3ea36354f9c191ac6db8e11b52" => :high_sierra
    sha256 "8f43334d17750ca4e08dd0b3905e1c206549ed95f16d62bb57dfd8701b3f7cbe" => :sierra
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
