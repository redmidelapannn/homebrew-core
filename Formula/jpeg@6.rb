class JpegAT6 < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v6b.tar.gz"
  sha256 "75c3ec241e9996504fe02a9ed4d12f16b74ade713972f3db9e65ce95cd27e35d"

  bottle do
    cellar :any
    sha256 "5e982458b8955769ff1d10b0922ccbfb2b20289e8ac919d77a7106ea268d835b" => :sierra
    sha256 "6c5dc621e232840649f5badc55492430434e08523613ce69324f0c40f43ba246" => :el_capitan
    sha256 "1ecf9ad7f9e74631112ba70430fefdb74449cf25f23e50e5af1dde502e43532c" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "libtool" => :build

  def install
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"

    system "make", "install", "install-lib", "install-headers",
                   "mandir=#{man1}", "LIBTOOL=glibtool"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
