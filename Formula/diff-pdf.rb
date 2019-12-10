class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 8

  bottle do
    cellar :any
    sha256 "add53d7ba1d00942090778634a6b394d7488422b0fbc5398a14250b50539edc1" => :catalina
    sha256 "c4cec3afb9a38575286c881c684bdb36027b2b172e867ff124ebcfa76fa538ed" => :mojave
    sha256 "542715a2688df6a0003955b8605ff0ecfe6c67a9aec709a7f00747773a95a125" => :high_sierra
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
