class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 39

  bottle do
    cellar :any
    sha256 "f85cbf8e7f86546831c1c0714d144a22bd862e3105dd81be0269da4489c38149" => :mojave
    sha256 "c9de993d642cb1638b964d994f45eba569690943653f5cc35b3833dde94f9c94" => :high_sierra
    sha256 "356a202329cc1c4e89cb287cf16ef4e7a26a15da6da5dbac1d251971a44cb628" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
    system "./bootstrap"
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
