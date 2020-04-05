class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-2/singular-4.1.2p5.tar.gz"
  version "4.1.2p5"
  sha256 "743593fa17e0f87ff2ab61e87653e95c6c00a615e3a2e6fb1f0e43461473b89f"

  bottle do
    sha256 "6ebe00e9bcf804b5fcfd71200a260e13525648a22e377493f357e115a9203de6" => :catalina
    sha256 "76f244071719eb7f711cb31e5b35dbba1c8df4e6d8380ccecdc7bb6d8035f65a" => :mojave
    sha256 "b87674f0cc69b1ad957d54b8af9ca76d2edda2b70f16e0f2d6881b5f7b6f3bf3" => :high_sierra
  end

  head do
    url "https://github.com/Singular/Sources.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python"].opt_bin}/python3",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
