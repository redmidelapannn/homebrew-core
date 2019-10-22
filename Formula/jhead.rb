class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.03.tar.gz"
  sha256 "82194e0128d9141038f82fadcb5845391ca3021d61bc00815078601619f6c0c2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "215c2227a5f615815c1657c0df656ed62e5f29b3df27a6044d50d4e386899f55" => :catalina
    sha256 "1178b84627e09581e0b089f2226a876bb85bb02328e26cbcdc71426c14100119" => :mojave
    sha256 "9d5ec17f5dd0fafc4dd0b0cdf09f6de501d027c571630785b61a4cfe97ff99c5" => :high_sierra
  end

  # Patch to provide a proper install target to the Makefile. The patch has
  # been submitted upstream through email. We need to carry this patch until
  # upstream decides to incorporate it.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/jhead/3.00.patch"
    sha256 "743811070c31424b2a0dab3b6ced7aa3cd40bff637fb2eab295b742586873b8f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end
