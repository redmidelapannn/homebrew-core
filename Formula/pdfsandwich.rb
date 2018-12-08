class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8f120fca8de96fd64d68921ecdafce95aef912dca619b049086895edefd6c83c" => :mojave
    sha256 "0fc4f2d050eb16abcf7ff8651cdb5546959d7e19683cf738c98187937d28c023" => :high_sierra
    sha256 "3b6ad1042c7e4ea8e032801fd5282ca17fae01296815d6045c46353dfb180f09" => :sierra
  end

  depends_on "gawk" => :build
  depends_on "ocaml" => :build
  depends_on "exact-image"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "poppler"
  depends_on "tesseract"
  depends_on "unpaper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["poppler"].opt_bin}:$PATH")
  end

  test do
    system "#{bin}/pdfsandwich", "-o", testpath/"test_ocr.pdf",
           test_fixtures("test.pdf")
    assert_predicate testpath/"test_ocr.pdf", :exist?,
                     "Failed to create ocr file"
  end
end
