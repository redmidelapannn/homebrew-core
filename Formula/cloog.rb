class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.bastoul.net/cloog/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "d0ce363016302b60e9be70070979c55b9be6fd3655357272d22232d0216e8c12" => :mojave
    sha256 "2018b070705c916c69f767fb8e6008c3bec0bf6a7907e899b986015d54bb3c7b" => :high_sierra
    sha256 "1fa4e97bbd6a8fcd4fd7ae83a45ac1ce282be3c57e43e24e4803e35d2da18ecc" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"

  resource "isl" do
    url "http://isl.gforge.inria.fr/isl-0.18.tar.xz"
    mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
    sha256 "0f35051cc030b87c673ac1f187de40e386a1482a0cfdf2c552dd6031b307ddc4"
  end

  def install
    resource("isl").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--with-gmp=system",
                            "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
      system "make", "install"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{libexec}"
    system "make", "install"
  end

  test do
    cloog_source = <<~EOS
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
