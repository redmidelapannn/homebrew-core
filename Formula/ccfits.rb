class Ccfits < Formula
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"

  bottle do
    cellar :any
    sha256 "e3b6d5a816198dd467ee7856fee708d2fd0985f8b152cb57a6abcd198b9d9ef6" => :catalina
    sha256 "da2e27bbac930acc9f5f96750d9ea67ebb50c90a28e397d0e1afa14897b87f83" => :mojave
    sha256 "dd9953634ecd05f3f1abbbdee696a0a6ac5c4e5fbe6cc5499b3064e530b8cfdb" => :high_sierra
  end

 
  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
