class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz"
  sha256 "5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86"

  bottle do
    sha256 "d59b767fb2f7f879706dc5756d0518ab54254951a7d53fd281ae2df087c6a808" => :mojave
    sha256 "d768905fb1389686b5e09b94b5818c3174dea77ba0cade4e31d208f93d3dad67" => :high_sierra
    sha256 "4e6d19b3a1f120a80dc8d2f804288c199abd2ae8e98d0b1dcf9d95f5ae47cba8" => :sierra
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
