class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 2

  bottle do
    rebuild 2
    sha256 "00273af48295bb4be3346cf6389e63dfdadc6ae36117f8b192062fec1c6f3170" => :mojave
    sha256 "e6fec959c1e050146dda871b47b31058fc688115abf5dc9961878cdfcc88fb2f" => :high_sierra
    sha256 "3c1845a1b84d7608fd140fb4cb34bbbae2bbd839f991082e2ba410309d28e74f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"

  # Fix pointer cast issue
  # https://sourceforge.net/p/bochs/patches/537/
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9b520dd4c/bochs/xcode9.patch"
      sha256 "373c670083a3e96f4012cfe7356d8b3584e2f0d10196b4294d56670124f5e5e7"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-cdrom
      --enable-clgd54xx
      --enable-cpu-level=6
      --enable-debugger
      --enable-debugger-gui
      --enable-disasm
      --enable-fpu
      --enable-iodebug
      --enable-large-ramfile
      --enable-logging
      --enable-long-phy-address
      --enable-pci
      --enable-plugins
      --enable-readline
      --enable-show-ips
      --enable-smp
      --enable-usb
      --enable-vmx=2
      --enable-x86-64
      --with-nogui
      --with-sdl2
      --with-term
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<~EOS
      panic: action=fatal
      error: action=report
      info: action=ignore
      debug: action=ignore
      display_library: nogui
    EOS

    expected = <<~EOS
      Bochs is exiting with the following message:
      \[BIOS  \] No bootable device\.
    EOS

    command = "#{bin}/bochs -qf bochsrc.txt"

    # When the debugger is enabled, bochs will stop on a breakpoint early
    # during boot. We can pass in a command file to continue when it is hit.
    (testpath/"debugger.txt").write("c\n")
    command << " -rc debugger.txt"

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
