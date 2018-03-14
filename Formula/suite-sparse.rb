class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-6.0.0.tar.gz"
  sha256 "27241827bf6f3f39f4f6070969455a15578851086c9552747b255e0edb5a0ced"

  bottle do
    cellar :any
    sha256 "23805bfcd82e16867bf084fae2891081f36989532745ef7286d585e477183df9" => :high_sierra
    sha256 "881ecac87decd57de7be6eecf140088a1915ee587400b41f36b45a117dede2dc" => :sierra
    sha256 "faa1cd7f0353cfbf62993297c36e182be27b4efc0b4af636860507a34fcbe1c2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "metis"

  def install
    mkdir "GraphBLAS/build" do
      system "cmake", "..", *std_cmake_args
    end

    args = [
      "INSTALL=#{prefix}",
      "BLAS=-framework Accelerate",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
    ]
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    system "./test"
  end
end
