class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.3.tar.xz"
  sha256 "802f7ee309dcc547d65a68d61ebd6526762d26c3051f52caebe2189ac1ffd72e"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    rebuild 1
    sha256 "c6a3cd18df0aaa6ccfde6ecfc5c049a11e0064e8bc543af70a007d5eae19ae60" => :catalina
    sha256 "d7b627278a373561f8a451c0ecb6fd509b40d575450164101b89e186435e302e" => :mojave
    sha256 "b815d21a674326ac844d40852e91f187a966f8aa9c5b412cf651702349cd12f4" => :high_sierra
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-targets=all
      --with-python=/usr
      --disable-binutils
    ]

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    system "make", "install-gdb"
  end

  def caveats; <<~EOS
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin

    On 10.12 (Sierra) or later with SIP, you need to run this:

      echo "set startup-with-shell off" >> ~/.gdbinit
  EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
