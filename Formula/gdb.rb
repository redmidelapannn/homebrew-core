class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.0.1.tar.xz"
  sha256 "3dbd5f93e36ba2815ad0efab030dcd0c7b211d7b353a40a53f4c02d7d56295e3"
  revision 1

  bottle do
    sha256 "10ebe48c598722a0beee7bfae403b15c1d4687c70ebc17c1d1fbb68ae220873a" => :sierra
    sha256 "e83f25d1fa0ae5fdba3cf12254aa0b43a4b526a1be41d7733ef23e3273bf07b0" => :el_capitan
  end

  deprecated_option "with-brewed-python" => "with-python"
  deprecated_option "with-guile" => "with-guile@2.0"

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile@2.0" => :optional
  depends_on "expat" => :optional

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--enable-targets=all" if build.with? "all-targets"

    # uses homewbrew expat
    args << "--with-expat" if build.with? "expat"
    args << "--with-libexpat-prefix=/usr/local/opt/expat" if build.with? "expat"

    if build.with? "python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    inreplace ["bfd/Makefile", "opcodes/Makefile"], /^install:/, "dontinstall:"

    system "make", "install"
  end

  def caveats; <<-EOS.undent
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
