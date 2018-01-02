class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.9/nano-2.9.1.tar.gz"
  sha256 "41650407cf1d4b752f31dc05e7c63319957e3dc86e9fb6ad51760e8b36941d19"
  head "https://git.savannah.gnu.org/git/nano.git"

  bottle do
    rebuild 1
    sha256 "fe9658ff96ca4c2bbe3e8a5b583e5407aece4e503652ab6d65df06ee36671356" => :high_sierra
    sha256 "7502edce8f2da178b958bf857ac2e8fc0c24c0e6bfb55b6fd01afb3485aa2dbc" => :sierra
    sha256 "c16bb71752f02e0231ad6b694bf5fdb6d8ed8e5bcfe1704d7103bdba54e3236d" => :el_capitan
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
