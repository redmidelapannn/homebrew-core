class Form < Formula
  desc "The FORM project for symbolic manipulation of very big expressions"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/vermaseren/form/releases/download/v4.2.1/form-4.2.1.tar.gz"
  sha256 "f2722d6d4ccb034e01cf786d55342e1c21ff55b182a4825adf05d50702ab1a28"

  bottle do
    cellar :any
    sha256 "94430319e1a3b4c732d164b85a775d052a9e630fa079119091448937d740d2b9" => :catalina
    sha256 "e219d97384e7ad4bb094f98b77cddc79dc30d30e1618fc7f873f6b30a92b047d" => :mojave
    sha256 "124d408b3dc5b9416cae7317677022bba4db299cede31e9b94d8b06035ee8e7a" => :high_sierra
  end

  depends_on "gmp"
  depends_on "lzlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-zlib",
                          "--with-gmp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/form", "-v"
  end
end
