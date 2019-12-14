class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.32.tar.gz"
  sha256 "9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e"

  bottle do
    sha256 "f7cda0b2705f796e2fccc8612c2a18a1dd85c0bd9f51985f9f77c24f4a12be24" => :catalina
    sha256 "40467bb41a0d7651e11c73529c002e16f2c444b95b02d63e7969ef1474e42af1" => :mojave
    sha256 "01843c43d684ef2e61d1f954ecd978e18187231b2e3edbf9caa6629f48c97b0b" => :high_sierra
  end

  def install
    system "./configure", "--target=x86_64-elf",
                          "--enable-targets=all",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-elf-c++filt _Z1fv")
  end
end
