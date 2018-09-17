class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  head "http://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da9488e311f4b433312c0d92da1c3e045c4aab37f5e6de485f358b9bad4cbba2" => :mojave
    sha256 "cb469ec1e983ea3528d0a5fb55519dc85128a02432f65cd2c9056023b19244c3" => :high_sierra
    sha256 "9e4eb91a03c3cea551aaee64553944b9374a51c7cf283d56fe7bc7477b58f0d5" => :sierra
    sha256 "caf92968865b848b1f249a572dfe39c5ea2c792191c42676f025d7915af5e464" => :el_capitan
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
