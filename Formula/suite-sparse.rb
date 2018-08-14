class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.3.0.tar.gz"
  sha256 "90e69713d8c454da5a95a839aea5d97d8d03d00cc1f667c4bdfca03f640f963d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "185129b549aa9e30ac1d0eef61ad566c486dc5efa019ce151bf03295a05d2ecd" => :high_sierra
    sha256 "f2ef39398a9277f69c9aada40b370b013a299e514d58cd6bc6d8cb6cc676a93b" => :sierra
    sha256 "01a06dfa13e73c3462d90416de820804c34a013fed26cfbff147eb4b32930c5e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "metis"

  conflicts_with "mongoose", :because => "suite-sparse vendors libmongoose.dylib"

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
