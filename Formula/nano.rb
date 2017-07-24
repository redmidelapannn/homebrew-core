class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.8/nano-2.8.6.tar.gz"
  sha256 "3725aa145880223b2c4d0b3fa08220e1633f2d341917f49d028e067fc12cce49"

  bottle do
    rebuild 1
    sha256 "6b56299c6a0e78aa48dd7e561edfea38b2129f3a8ff5adff9de3795299d7c563" => :sierra
    sha256 "b5b7b8d3fc3569ffcf3870bbd9322b001ae96623c25994996e927038a5e2965d" => :el_capitan
    sha256 "9aea0b5bcc96131ce3ca0b431e228125e6c6a36dc6544b0c1de3799ace9fcb92" => :yosemite
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
