class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "https://udp.github.io/lacewing/"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1
  head "https://github.com/udp/lacewing.git"

  bottle do
    cellar :any
    rebuild 4
    sha256 "6392cc06b8c9897325c93f808286ec3e95e062caa3d9806481f8792d1e4a2006" => :high_sierra
    sha256 "6b3fb2c9ee261185da0aa649d5cfd52d654f5ae028002a5b69693c24f121b6b5" => :sierra
    sha256 "d37d62796700b7407f10ccd58fcb0b78fd7c30ce9c978c590ec711337aec6e37" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # https://github.com/udp/lacewing/issues/104
    mv "#{lib}/liblacewing.dylib.0.5", "#{lib}/liblacewing.0.5.dylib"
  end
end
