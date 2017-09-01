class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 1

  bottle do
    rebuild 1
    sha256 "e49d9bf3752ddc49d964d9606a4ca3d6c19735fee3c91b2dee9feeb5bf367887" => :sierra
    sha256 "362b4dce96c03666ae0fdd173e487f83a3b3e54268c84967d44bf6dbd4ee149a" => :el_capitan
    sha256 "c13e608c9624a8a1b74cc7d2dc900cbc6de593ead830f7d38b86fb6334ec834e" => :yosemite
  end

  option "with-gdb-stub", "Enable GDB Stub"
  option "without-sdl2", "Disable graphical support"

  depends_on "pkg-config" => :build
  depends_on "sdl2" => :recommended

  # Fix pointer cast issue
  # https://sourceforge.net/p/bochs/patches/537/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9b520dd4c/bochs/xcode9.patch"
    sha256 "373c670083a3e96f4012cfe7356d8b3584e2f0d10196b4294d56670124f5e5e7"
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
      --enable-smp
      --enable-long-phy-addres
      --with-term
    ]

    args << "--with-sdl2" if build.with? "sdl2"

    if build.with? "gdb-stub"
      args << "--enable-gdb-stub"
    else
      args << "--enable-debugger"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<-EOS.undent
        panic: action=fatal
        error: action=report
        info: action=ignore
        debug: action=ignore
        display_library: nogui
      EOS

    expected = <<-ERR.undent
        Bochs is exiting with the following message:
        \[BIOS  \] No bootable device\.
      ERR

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
