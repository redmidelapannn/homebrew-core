class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.10.0.tar.bz2"
  sha256 "eb38aa93f93e8ab282d97e2582fbaea88b3f889a08cbc9dbf20059c3779d5cd8"

  bottle do
    rebuild 1
    sha256 "90181ab278a5cefc2e5246c554cc9b09f5e16a0b6776c04d0a5e3e87b5e8c80e" => :mojave
    sha256 "5ae35ade95acd545b707ba3fb3c7398915a26d66360cb9fcaff09d78236347d4" => :high_sierra
    sha256 "3f55b92f377243f92be1c64f4cdf2cb11610dcf1312c8aa18b9064b52b05797a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    # See https://github.com/octo/liboping/issues/36
    inreplace "src/oping.c", "HAVE_NCURSESW_NCURSES_H", "HAVE_NCURSESW_CURSES_H"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end

  test do
    system bin/"oping", "-h"
    system bin/"noping", "-h"
  end
end
