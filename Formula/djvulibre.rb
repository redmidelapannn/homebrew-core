class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.27/djvulibre-3.5.27.tar.gz"
  sha256 "e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f"

  bottle do
    rebuild 2
    sha256 "c3f0d9ea238bc008a621917b7239b1bd58c0be5e254271295e85f6186b87bc30" => :sierra
    sha256 "343940fdca6c4efc8b40f5afcc34edf0897c4e3e4ee11a09311eb786474e4e13" => :el_capitan
    sha256 "c16189afb5c0ca8ecae714bf1fdd1911d763bc9871a82407a328a906d4100788" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/djvu/djvulibre-git.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./autogen.sh" if build.head?
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
