class Par2tbb < Formula
  desc "Create and repair data files using Reed Solomon coding"
  homepage "http://chuchusoft.com/par2_tbb/"
  url "https://web.archive.org/web/20141212202746/http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20141125.tar.gz"
  sha256 "17a5bb5e63c1b9dfcf5feb5447cee60a171847be7385d95f1e2193a7b59a01ad"

  bottle do
    cellar :any
    sha256 "1b1e0c2395512030adcdbdfd4835a55f50d857c4c05c3d48830024e42da389dc" => :high_sierra
    sha256 "9816c9c69de0c41e5f51c23e68481f13b2716a22e70a6ea5fa9d26829a3ecdde" => :sierra
    sha256 "e17915ad514052f1aa9ebb246baebe6487cf0a18ef2a8f40448531ed25976a5f" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tbb"

  conflicts_with "par2",
    :because => "par2tbb and par2 install the same binaries."

  fails_with :clang do
    build 318
  end

  def install
    system "autoreconf", "-fvi"
    # par2tbb expects to link against 10.4 / 10.5 SDKs
    inreplace "Makefile.in", /^.*-mmacosx-version.*$/, ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/par2", "create", "test", "test.out"
    system "#{bin}/par2", "verify", "test.par2"
  end
end
