class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.0.tar.gz"
  sha256 "b5194ce2f52392b2cd6d8f155d73f0141723af8f3409779d8dc5b188a6f07379"

  bottle do
    cellar :any
    sha256 "e8639139020aada7e5a76ca46e79c29587d2946c4e49f8f1aa6e9081892c0aae" => :el_capitan
    sha256 "2d81ba8835e5bcdb368ea2b8e33f4c269becb75b63d4bdc7c242558669961512" => :yosemite
    sha256 "cc17df9adf2839b7f682b8d5bc67a87d8840056198d106ab9b486e702dd072d4" => :mavericks
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
