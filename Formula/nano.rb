class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.4.tar.gz"
  sha256 "23ffc2de52d687739fed6dc2fc94df36aa7da7bb52c8740c523fdd7336fdbc8c"

  bottle do
    rebuild 1
    sha256 "f7b50cb5a6c8a2396686f09ced7e596d83cc81b25ffccf0c34fd6be19cd4e918" => :sierra
    sha256 "0a891201c8b945402985be129916bbd635441b409ff3b22c52f7bd171734bd95" => :el_capitan
    sha256 "b181905d5cfa54259557976cae610e0020a4a8069049cac2b523526194a399df" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

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
