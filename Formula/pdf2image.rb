class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"

  bottle do
    rebuild 1
    sha256 "601534f37e2919e041b9a1a11fc3600c5cafe179a1061485f4831dccc33d9aaf" => :sierra
    sha256 "835eeece3ad180ac45bc8cae216c2d5c913774b81ab3622796beb939d4139e2c" => :el_capitan
    sha256 "c2e272f0bef8ee7f6d2a612f1471931a5ccc47402cb09879356aab50ed48cb5f" => :yosemite
  end

  depends_on :x11
  depends_on "freetype"
  depends_on "ghostscript"

  conflicts_with "poppler", "xpdf",
    :because => "pdf2image, poppler, and xpdf install conflicting executables"

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # https://github.com/flexpaper/pdf2json/issues/2
    inreplace "Makefile", "/man/", "/share/man/"

    # Fix incorrect variable name in Makefile
    inreplace "src/Makefile", "$(srcdir)", "$(SRCDIR)"

    # Add X11 libs manually; the Makefiles don't use LDFLAGS properly
    inreplace ["src/Makefile", "xpdf/Makefile"],
      "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2image", "--version"
  end
end
