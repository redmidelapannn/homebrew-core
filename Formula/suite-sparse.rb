class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz"
  sha256 "b9a98de0ddafe7659adffad8a58ca3911c1afa8b509355e7aa58b02feb35d9b6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "159adb29b8e4878c08468ec0fe3d2f4ee98c9977ee23449d2ffd31b158cf12ca" => :sierra
    sha256 "41a4805719104a4a970dd6143fe3f15dcfba2281f2e7adda0c0dde6273e05cce" => :el_capitan
    sha256 "b2c9b8f46d8e6c5c07c9867016109c7b45773216185837c1b07641fe80ea95b6" => :yosemite
  end

  depends_on "metis"

  def install
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-framework Accelerate",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
    ]
    system "make", "library", *args
    system "make", "install", *args
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    system "./test"
  end
end
