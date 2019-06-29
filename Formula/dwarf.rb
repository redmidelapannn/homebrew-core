class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "67b9b94682cc68c189e30e057d541104aae5b20de2cf83aa888cff8a30f41161" => :mojave
    sha256 "d3619309db543c7bc5d28a9d40c2911c0d968e9dd5f186abbea8e7f8765bf42e" => :high_sierra
    sha256 "c0e8d574bcfbd8586c125c1f0d3bd5c05e1aaaf04d542871383547582de91bef" => :sierra
  end

  depends_on "flex"
  depends_on "readline"
  uses_from_macos "bison"

  def install
    %w[src/libdwarf.c doc/dwarf.man doc/xdwarf.man.html].each do |f|
      inreplace f, "/etc/dwarfrc", etc/"dwarfrc"
    end

    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("hello world\\n");
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    output = shell_output("#{bin}/dwarf -c 'pp $mac' test")
    assert_equal "magic: 0xfeedfacf (-17958193)", output.lines[0].chomp
  end
end
