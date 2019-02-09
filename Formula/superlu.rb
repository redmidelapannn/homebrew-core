class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "https://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2509fe0a6adebedac9bbc366cc32bdd8d59b64d2440a2243db7ebf87b53d0c05" => :mojave
  end

  depends_on "veclibfort"

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"

    args = ["SuperLUroot=#{buildpath}",
            "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
            "CC=#{ENV.cc}",
            "BLASLIB=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"]

    system "make", "lib", *args
    lib.install Dir["lib/*"]
    (include/"superlu").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]

    # Source and data for test
    pkgshare.install "EXAMPLE/dlinsol.c"
    pkgshare.install "EXAMPLE/g20.rua"
  end

  test do
    system ENV.cc, pkgshare/"dlinsol.c", "-o", "test",
                   "-I#{include}/superlu", "-L#{lib}", "-lsuperlu",
                   "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
