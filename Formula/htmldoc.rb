class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.6/htmldoc-1.9.6-source.tar.gz"
  sha256 "4f49385a55c14de2b432b737593b67a68b40415bf5cc276e0a14ca0ce2e00ef3"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "e1175155da8f5f0577da9f0efa4d4f896871b00fd8d11977e7bd24c076cf0ea9" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
