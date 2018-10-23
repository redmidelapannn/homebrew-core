class I386ElfGcc < Formula
  desc "The GNU compiler collection for i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://mirrors.nju.edu.cn/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.gz"
  sha256 "1b0f36be1045ff58cbb9c83743835367b860810f17f0195a4e093458b372020f"
  depends_on "gettext" => :build
  depends_on "gmp" => :build
  depends_on "i386-elf-binutils" => :build
  depends_on "libmpc" => :build
  depends_on "mpfr" => :build
  depends_on "xz" => :build

  def install
    mkdir "gcc-build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--enable-languages=c,c++",
                             "--without-isl"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
      binutils = Formulary.factory "i386-elf-binutils"
      ln_sf binutils.prefix/"i386-elf", prefix/"i386-elf"
    end
  end

  test do
    system "#{bin}/i386-elf-gcc", "--version"
  end
end
