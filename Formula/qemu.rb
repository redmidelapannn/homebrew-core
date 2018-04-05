class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-2.11.1.tar.bz2"
  sha256 "d9df2213ceed32e91dab7bc9dd19c1af83f91ba72c7aeef7605dfaaf81732ccb"
  head "https://git.qemu.org/git/qemu.git"

  bottle do
    rebuild 1
    sha256 "83c154c99b6e27b1628679b058de24db66fffb39afb21539f7ac4552830855b4" => :high_sierra
    sha256 "c927b9ea279c2299478f62470ea3fefa510797b9175b318ea6c59e425ccae1e9" => :sierra
    sha256 "04f61e79087e72211b4fd13ce26974c861fe8cc9c4832e23f7af20281fc46de0" => :el_capitan
  end

  devel do
    url "https://download.qemu.org/qemu-2.12.0-rc2.tar.xz"
    sha256 "b8dfe1f5771ca48225f408f0ec2c19519536fe534581b2d21a5e4eebab94220a"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "gnutls"
  depends_on "glib"
  depends_on "ncurses"
  depends_on "pixman"
  depends_on "libpng" => :recommended
  depends_on "vde" => :optional
  depends_on "sdl2" => :optional
  depends_on "gtk+" => :optional
  depends_on "libssh2" => :optional
  depends_on "libusb" => :optional

  deprecated_option "with-sdl" => "with-sdl2"

  fails_with :gcc_4_0 do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  fails_with :gcc do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "test-image" do
    url "https://dl.bintray.com/homebrew/mirror/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --extra-cflags=-DNCURSES_WIDECHAR=1
    ]

    # Cocoa and SDL2/GTK+ UIs cannot both be enabled at once.
    if build.with?("sdl2") || build.with?("gtk+")
      args << "--disable-cocoa"
    else
      args << "--enable-cocoa"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("sdl2") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    args << (build.with?("libssh2") ? "--enable-libssh2" : "--disable-libssh2")

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    resource("test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
