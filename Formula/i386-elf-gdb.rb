class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.1.tar.xz"
  sha256 "699e0ec832fdd2f21c8266171ea5bf44024bd05164fdf064e4d10cc4cf0d1737"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    rebuild 1
    sha256 "e96afc666a2bfc4b0ccc7da302eb159ff3cf5493a85a77959cbef11699510f80" => :catalina
    sha256 "55291b490d03b8802c106b2ca087fa84225a12115b96058c8edd325195cbbc3f" => :mojave
    sha256 "409c8bac4ca348737d4b6eede89b0e593d196314308dcf831d7c32643e0fd682" => :high_sierra
  end

  conflicts_with "gdb", :because => "both install include/gdb, share/gdb and share/info"

  def install
    mkdir "build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--disable-werror"
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
