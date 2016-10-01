class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.1.tar.gz"
  sha256 "d00ed04a4f58cc1163cc581cf738e53d872ea59f9e5f94fa9cc61ef59b8d9c13"
  revision 1

  bottle do
    cellar :any
    sha256 "a52c04207e88ebdcf7cceca43044986c47ba5b9180858bff29f71d5f7ae6f0fd" => :sierra
    sha256 "953e5d10b2cb3e5c08ae4e96f1dcc4968a498c325107ed808f430428162d0f67" => :el_capitan
    sha256 "9695d678dbf9103c4595dd4180bc0885910f0d29b43094ca5b0d1481dfcdda59" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "poppler"
  depends_on "boost@1.61"
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
