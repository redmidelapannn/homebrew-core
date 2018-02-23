class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v2.1.tar.gz"
  sha256 "6113c2b6272334af710ba486e8312faa3cee5bd6dc8ca422d00437725e2b602a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "66826680cdac8391567f0b78eeee08412ab741513722bc18eeea0f625ee695ec" => :high_sierra
    sha256 "53cebc4afba3d0a682745fc0e8ee6ef6150f0952c8a2d395101782c99f8f69da" => :sierra
    sha256 "8120357329c4d76c6d5d391af010275ad3535d78d4b7eb06349e8af9cb5c0ce2" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
