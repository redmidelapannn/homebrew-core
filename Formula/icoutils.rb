class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "https://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.2.tar.bz2"
  sha256 "e892affbdc19cb640b626b62608475073bbfa809dc0c9850f0713d22788711bd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "934b8c5e466f6bcaea4ada1a936baf3b325ab09a2a1a2aa2e0185d5286087313" => :high_sierra
    sha256 "d371236074d87bee76f5873ff8a5c3b3d6a5b9335d1585b99961ba5d4db77296" => :sierra
    sha256 "f8a998fd736feec59d49e4b668c6235369a380780117e5e44768c9338004c332" => :el_capitan
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"icotool", "-l", test_fixtures("test.ico")
  end
end
