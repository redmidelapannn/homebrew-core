class Flint < Formula
  desc "Fast Library for Number Theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"

  bottle do
    cellar :any
    sha256 "7c47103e4ce98c6b18ff5beb329f779c480c427e389ee7749a2f2665a09a5bc4" => :mojave
    sha256 "078c1e6b8b2d746798f9e3b55b937d779776f4ed8aaade1e450080374796631b" => :high_sierra
    sha256 "e819fbe16a6be03e1434f1db290eb8f9d8bc476144b9cbb2285ba216ee925bba" => :sierra
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    ENV["DYLD_LIBRARY_PATH"] = "/System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install "examples/radix.c"
  end

  test do
    system ENV.cc, pkgshare/"test/radix.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}", "-lflint", "-lgmp", "-o", "test"
    system "./test"
  end
end
