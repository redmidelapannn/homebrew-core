class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.3.0.tar.gz"
  sha256 "31ecc3dc09e1e561502b4c94f965ed6b167c03e9418438c4a7ad5bad2c785f9a"

  bottle do
    rebuild 1
    sha256 "2ef3b922361a04d08bf639f4fb93699b146c27e6b12c40d12d44be151e8af2da" => :high_sierra
    sha256 "bbb9fa04ec7d5e145866736f6a0be214dc65a066f07dad2d99de89f544766575" => :sierra
    sha256 "e8e2368f3134b8bb5869fc080bf85ec8af49e2f2f98adaaea9c75a47b487b188" => :el_capitan
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
