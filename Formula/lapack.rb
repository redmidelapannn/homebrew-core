class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "https://www.netlib.org/lapack/"
  url "https://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
  sha256 "deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6"
  revision 1
  head "https://github.com/Reference-LAPACK/lapack.git"

  bottle do
    rebuild 1
    sha256 "f37ca05f288da9e252dd626eb7881885f34534a5a43895026c7ae7709a241e6e" => :high_sierra
    sha256 "68ab0ad3ebbe305e0042326eaf745509220a68087b204f9f1f99e31d263c7fab" => :sierra
    sha256 "15dbf13b1ee666e5900d53e2961f0971b4f936da2f74573816750ab48bfa18c7" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    ENV.delete("MACOSX_DEPLOYMENT_TARGET")

    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_SHARED_LIBS:BOOL=ON",
                      "-DLAPACKE:BOOL=ON",
                      *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lp.cpp").write <<~EOS
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "lp.cpp", "-I#{include}", "-L#{lib}", "-llapacke", "-o", "lp"
    system "./lp"
  end
end
