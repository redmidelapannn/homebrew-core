class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.1.tar.gz"
  sha256 "41650407cf1d4b752f31dc05e7c63319957e3dc86e9fb6ad51760e8b36941d19"

  bottle do
    rebuild 1
    sha256 "35cdbba8d13f0b0c5682b322fda9f39faa9472f938dd5472288b4dde9bf2a9f8" => :high_sierra
    sha256 "289b62df52ac544c1e4e23a8915cc4f4483fee69a868b4754ff90b4a330e7ff8" => :sierra
    sha256 "3be68a938b62401c2bf7aebdbd4c3538a17c4ea8d1234c76ee0d70af3dc6c2ac" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  # 28 Nov 2017 "stat: fix compilation failure on macOS Sierra"
  # gnulib commit https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commit;h=cbce9423af01902fde4d84c02eedb443947f8986
  # nano bug report https://savannah.gnu.org/bugs/?52546
  patch :p0 do
    url "https://savannah.gnu.org/bugs/download.php?file_id=42510"
    sha256 "a07c826502b119113be3a376fac1c0be8e07f2b29b0a201ee95b2678317934dd"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
