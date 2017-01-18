class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.cloog.org/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "acc205278c91ab7626350526824794d27f9c9fd71abfca6b3039ec492bb0ca35" => :sierra
    sha256 "bd7b782eb38ed1323a89e66ea2a1ca3fa4bda62d7e810f9311beaeebc9f40e72" => :el_capitan
    sha256 "0ddcf4d4521993b61eb4a634212865486486be0b8849fa9219b92330dc149dad" => :yosemite
  end

  head do
    url "http://repo.or.cz/r/cloog.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  def install
    system "./autogen.sh" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}",
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match %r{Generated from /dev/stdin by CLooG}, output
  end
end
