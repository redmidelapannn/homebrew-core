class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 2

  bottle do
    rebuild 1
    sha256 "c5fd4c8cbfdec09a213774ee56d25fec6d751da375445e096327b88e4651b460" => :high_sierra
    sha256 "d75389a529c9fb31278229a744b89f02aabc7324f38b66aae0224b87c0b0acd1" => :sierra
    sha256 "eed513240abe9c57e8af9f4ed8a2e6ebf04fce87edb1efeff7a1991d4a8ae490" => :el_capitan
  end

  option "with-gdb-stub", "Enable GDB Stub"
  option "without-sdl2", "Disable graphical support"

  depends_on "pkg-config" => :build
  depends_on "sdl2" => :recommended

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
      --with-nogui
      --enable-disasm
      --disable-docbook
      --enable-x86-64
      --enable-pci
      --enable-all-optimizations
      --enable-plugins
      --enable-cdrom
      --enable-a20-pin
      --enable-fpu
      --enable-alignment-check
      --enable-large-ramfile
      --enable-debugger-gui
      --enable-readline
      --enable-iodebug
      --enable-show-ips
      --enable-logging
      --enable-usb
      --enable-cpu-level=6
      --enable-clgd54xx
      --enable-avx
      --enable-vmx=2
      --enable-long-phy-address
      --with-term
    ]

    args << "--with-sdl2" if build.with? "sdl2"

    if build.with? "gdb-stub"
      args << "--enable-gdb-stub"
    else
      args << "--enable-debugger"
      args << "--enable-smp"
    end

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
    if build.without? "gdb-stub"
      # When the debugger is enabled, bochs will stop on a breakpoint early
      # during boot. We can pass in a command file to continue when it is hit.
      (testpath/"debugger.txt").write("c\n")
      command << " -rc debugger.txt"
    end

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
