class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz"
  sha256 "5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86"

  bottle do
    sha256 "560502b3d41c665369cd4dcbab7dd8bfeb0e2dce3e16c6c0aba7562dbb7350eb" => :mojave
    sha256 "2c7a1a5ce2b73d5f65c0cc88a0105578fd0b6e22e4e5e9388440a917da0a99f4" => :high_sierra
    sha256 "def60adbbbffad9729a4e6510ba7868ab27142a4d8aaee0f6c34e537e62a748e" => :sierra
  end

  def install
    system "./configure", "--target=i386-elf",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/i386-elf-c++filt _Z1fv")
  end
end
