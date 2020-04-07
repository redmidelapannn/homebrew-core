class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"

  bottle do
    rebuild 1
    sha256 "69f7776970d56a44935485f4caa67b3e07fe32328ec50db6ce378597df81a375" => :catalina
    sha256 "d65f584062a5ef2036750204f83fea3d58514f39740de25a86df754e39dcf950" => :mojave
    sha256 "452c77cdf3b6190fb3cba1251af14005b27375cf8650953adea4cd7c81e038e0" => :high_sierra
  end

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on :x11

  conflicts_with "pdftohtml", "poppler", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

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
