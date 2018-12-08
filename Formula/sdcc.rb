class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.8.0/sdcc-src-3.8.0.tar.bz2"
  sha256 "b331668deb7bd832efd112052e5b0ed2313db641a922bd39280ba6d47adbbb21"
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    rebuild 1
    sha256 "ead7d43fd6e83691d9e50dc6313a05d39487c058c261c812f43f6549e59ebc5a" => :mojave
    sha256 "4fd5ef1372a34a6405768e9b96b3bda3f744391b9ac9b626307549c15eb04577" => :high_sierra
    sha256 "f5e2bf3b76b4cdf1479932f2222df9ddcc84c4814db03abc7fb9a173c52fac9a" => :sierra
  end

  depends_on "boost"
  depends_on "gputils"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
