class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.8.0/sdcc-src-3.8.0.tar.bz2"
  sha256 "b331668deb7bd832efd112052e5b0ed2313db641a922bd39280ba6d47adbbb21"
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    rebuild 1
    sha256 "762984c15c7c1e815f21c23a2b4fede6725567cad4943a8234ecee1338813114" => :mojave
    sha256 "f911959d6466b43a89c2f1c84f50cc88df68f6632d53242cc5557beb6dec59a4" => :high_sierra
    sha256 "19f3f4ea3712993664ac629bfa500ec731c1eee74198226439fa38399d68f772" => :sierra
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
