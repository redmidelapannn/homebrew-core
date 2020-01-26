class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.11/bochs-2.6.11.tar.gz"
  sha256 "63897b41fbbbdfb1c492d3c4dee1edb4224282a07bbdf442a4a68c19bcc18862"

  bottle do
    sha256 "ed107f4c5c36a6186dce161fa1d0370787783c4f60cb07c1d316922c3647bc09" => :catalina
    sha256 "8ab00cad6fe2bc0513184c5255a74824bf6400316ad9c9654010f6636dae9164" => :mojave
    sha256 "c703569de39c69053a7efed50228a151d7303ff97f1a24b31d7521bbbade2f18" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "ncurses"
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
      CXXFLAGS=-std=c++11
      --prefix=#{prefix}
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-evex
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
