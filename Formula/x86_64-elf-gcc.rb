class X8664ElfGcc < Formula
  desc "The GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz"
  sha256 "ea6ef08f121239da5695f76c9b33637a118dcf63e24164422231917fa61fb206"

  bottle do
    sha256 "bc6fe2fdef986564ce54f08234bad276600d47ca771f76b8da774186c7d9b03c" => :catalina
    sha256 "6633f21fba70c0c57880b6e4711e0084773d8a4e86e42af41ae631a5426a3d85" => :mojave
    sha256 "eaeeca0e18dfa2c12381ff1bd196932f88bd18fc91e1aed2116363cef034e736" => :high_sierra
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"

  def install
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=x86_64-elf",
                             "--enable-targets=all",
                             "--enable-multilib",
                             "--prefix=#{prefix}",
                             "--without-isl",
                             "--disable-werror",
                             "--without-headers",
                             "--with-as=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-as",
                             "--with-ld=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-x86-64", shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
  end
end
