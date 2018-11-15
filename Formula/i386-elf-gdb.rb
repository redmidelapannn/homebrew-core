class I386ElfGdb < Formula
  desc "The GNU Project debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz"
  sha256 "c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"

  bottle do
    sha256 "d45b9bac438352abee5d207a77a5957fe1f7bccae5f297bb128d57017bc4fa28" => :mojave
    sha256 "e6dce8df82b1fcdca4dd4d1d31bf77f219c142dc7eb50e273113dcf8d3291adf" => :high_sierra
    sha256 "24533a3aad07b3d85ac5a3e8fd7f3e8d175add7d142e905a74de89a1f208b0ad" => :sierra
  end

  def install
    mkdir "i386-elf-gdb-build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--with-gmp=#{prefix}",
                             "--with-libelf=#{prefix}",
                             "--with-build-libsubdir=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
