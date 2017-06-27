class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.2.tar.gz"
  sha256 "94e5888accae92380fd5e4b6a7ee4211f05814059a9f540b071a27993113be95"
  revision 2

  bottle do
    cellar :any
    sha256 "4647cc591c348281de3ca58a0aa150e695af6fab141d4cacfb886cf7b96de8e9" => :sierra
    sha256 "33de44172228a8a8efec75ea92cf82ad0712656cf570f14fd817b7c3c5ef121b" => :el_capitan
    sha256 "7b3a70c22e898ea3596f14fe91567a56dad514c719cfb12c7030409cb767f04a" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "poppler"
  depends_on "boost"
  depends_on "leptonica"
  depends_on "openssl"
  depends_on "rapidjson"

  def install
    ENV.cxx11

    system "autoreconf", "-i"
    system "./configure", "--with-openssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdftoedn", "-o", "test.edn", test_fixtures("test.pdf")
  end
end
