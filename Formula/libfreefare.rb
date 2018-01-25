class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  revision 2

  bottle do
    cellar :any
    sha256 "4c52d6a60226b54554928128277e14daa682941342c2e9388633b9ab6b3d2a96" => :high_sierra
    sha256 "123f3fb74733907389b29d6c3a3cbb7b137f625807f660e01aa671221027ec01" => :sierra
    sha256 "3d1d6de12ebb6daca1c655ddb4bc470e47525705078c3cd260a9c77e71f213ce" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
