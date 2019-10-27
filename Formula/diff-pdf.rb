class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 8

  bottle do
    cellar :any
    sha256 "05d18331396dd36d55a8deb2bea9b52de737dcf0f9a84725252a8a3a43e39e1e" => :catalina
    sha256 "5d30a4bfde6394788c44c5eef7cd4c6dbf3d06ea52c95f692086d059e1db47d6" => :mojave
    sha256 "8568d3a9a6604ea58de1033c5112f04f6e025d47fe874ee7d9567dd937c4ea3c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
