class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.11.7-src.tar.gz"
  sha256 "d70b46c3335c7abf21944aced2d9d2b54819ab84ed1a140b354d5e8cc9f0fb0a"
  revision 1
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    sha256 "bee907f12c1685a554d7a79f49c9ddb0a510f461405da01616cc3821d5ee3080" => :high_sierra
    sha256 "454a834d0b41dce25504392f172f111ebe2ce8eec80246635c99152785dc0ed8" => :sierra
    sha256 "67016239757423ea6f8a90ae216d143f548b4a47a2034652a06c2ca23083e9be" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    lib.install "lib/libimagequant.a"
    include.install "lib/libimagequant.h"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
