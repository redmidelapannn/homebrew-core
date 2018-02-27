class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm-alpha"
  url "https://spiro.trikaliotis.net/Download/opencbm-0.4.99.99/opencbm-0.4.99.99.tar.bz2"
  sha256 "b1e4cd73c8459acd48c5e8536d47439bafea51f136f43fde5a4d6a5f7dbaf6c6"
  head "https://git.code.sf.net/p/opencbm/code.git"

  bottle do
    rebuild 1
    sha256 "2d83be1d98782118288d9bf172fcefa15393e94be42cf79682d7d5d4186589ae" => :high_sierra
    sha256 "3584cf03ec90bdb695fee6d46834bcec28037b22ddff4d314d76d501ebb14a6b" => :sierra
    sha256 "c8b419cee585751aaa531ebbb222a2262ac4284d5641094cc5ebd662e4ed9dd2" => :el_capitan
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "libusb-compat"

  # Fix "usb_echo_test.c:32:10: fatal error: 'endian.h' file not found"
  # Reported 24 Nov 2017 to www-201506 AT spiro DOT trikaliotis DOT net
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/48bd0fd/opencbm/endian.diff"
    sha256 "2221fab81cdc0ca0cfbd55eff01ae3cd10b4e8bfca86082c7cbffb0b73b651cf"
  end

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
