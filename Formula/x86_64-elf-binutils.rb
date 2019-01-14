class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz"
  sha256 "5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86"


  bottle do
    sha256 "6c0042acdd7e49783207f7100c33e7119e08ec7af6a8970ed263af92ac8415cb" => :mojave
    sha256 "e5f83059cb823ea0cf8b20e99e51fcec8e2bbe9d567dcd98306edaac4db2b3f2" => :high_sierra
    sha256 "9aab178b0a4330953616f3d0dfb5d377329e0f0c2118c769d2acbcc423cb989e" => :sierra
  end

  def install
    system "./configure", "--target=x86_64-elf",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-elf-c++filt _Z1fv")
  end
end
