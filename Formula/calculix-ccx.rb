class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.15.src.tar.bz2"
  version "2.15"
  sha256 "bc7dba721935af51b60c1b5aa1529a420476fc6432a7bec5254f8dfabaeb8a34"

  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "gcc" # for gfortran
  depends_on "libomp"

  resource "test" do
    url "http://www.dhondt.de/ccx_2.15.test.tar.bz2"
    version "2.15"
    sha256 "ee17e477aeae944c35853a663ac245c33b405c3750308c5d77e5ee9a4e609dd5"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.15.htm.tar.bz2"
    version "2.15"
    sha256 "0bfdef36076d3d1d1b7f8cd1d5a886915f7b0b54ed5ae7a7f71fa813ef655922"
  end

  resource "spooles" do
    # The spooles library is not currently maintained and so would not make a
    # good brew candidate. Instead it will be static linked to ccx.
    url "https://www.netlib.org/linalg/spooles/spooles.2.2.tgz"
    sha256 "a84559a0e987a1e423055ef4fdf3035d55b65bbe4bf915efaa1a35bef7f8c5dd"
  end

  def install
    (buildpath/"spooles").install resource("spooles")

    # Patch spooles library
    # Must specify the compiler in place as the CC env variable is not honored
    inreplace "spooles/Make.inc", "/usr/lang-4.0/bin/cc", ENV.cc
    inreplace "spooles/Tree/src/makeGlobalLib", "drawTree.c", "draw.c"

    # Build serial spooles library
    system "make", "-C", "spooles", "lib"

    # Extend library with multi-threading (MT) subroutines
    system "make", "-C", "spooles/MT/src", "makeLib"

    # Patch ccx makefile to remove LIBS as dependency for the ccx target
    inreplace "ccx_2.15/src/Makefile", "ccx_2.15: \$\(OCCXMAIN\) ccx_2.15.a  \$\(LIBS\)", "ccx_2.15: $(OCCXMAIN) ccx_2.15.a"

    fflags = %w[-Wall -O3 -fopenmp]
    cflags = %w[-Wall -O3 -I../../spooles -DARCH="Linux" -DSPOOLES -DARPACK -DMATRIXSTORAGE -DNETWORKOUT -DUSE_MT=1]
    arpacklib = `pkg-config --libs arpack`.chomp
    libs = %w[../../spooles/spooles.a -framework accelerate -lomp]
    libs << arpacklib
    args = %W[
      FC=gfortran
      CFLAGS=#{cflags.join(" ")}
      FFLAGS=#{fflags.join(" ")}
      DIR=../../spooles
      LIBS=#{libs.join(" ")}
    ]

    # Buid Calculix ccx
    target = Pathname.new("ccx_2.15/src/ccx_2.15")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.15/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.15/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "#{bin}/ccx_2.15", "spring1"
  end
end
