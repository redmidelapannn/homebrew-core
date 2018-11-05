class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.3.0.tar.gz"
  sha256 "31ecc3dc09e1e561502b4c94f965ed6b167c03e9418438c4a7ad5bad2c785f9a"
  head "git://git.calcurse.org/calcurse.git"

  bottle do
    rebuild 1
    sha256 "fd7efc6f70b643f017706d99cf14d327da8f66e6b4bd7280169ff8710013caff" => :mojave
    sha256 "dbafd955885442db102357724f69c49ffc83c7b01f761915a3f53381472104e2" => :high_sierra
    sha256 "15ac7a1bd4ec8a3278887b95a1fb4f55fedf46472bb2876f26ed850369857d9d" => :sierra
  end

  depends_on "gettext"

  if build.head?
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
