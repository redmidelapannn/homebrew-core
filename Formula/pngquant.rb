class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.11.7-src.tar.gz"
  sha256 "d70b46c3335c7abf21944aced2d9d2b54819ab84ed1a140b354d5e8cc9f0fb0a"
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8e9e90fb30ad2672960a8b1523dc42d1f3f3851c5e29779df85cfcf08e6de7c5" => :high_sierra
    sha256 "70402300e35984ac3c1a4661091a44f6e66926a4036737fcfced7b28310efaf0" => :sierra
    sha256 "fac5fcda9da72744f38b35534f04ad4213cb55c8ad7a4c629e7311f50c9d9e40" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
