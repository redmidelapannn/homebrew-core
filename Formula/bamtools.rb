class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz"
  sha256 "4abd76cbe1ca89d51abc26bf43a92359e5677f34a8258b901a01f38c897873fc"
  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "260b2637c320efd0c6369eef4809b0c40bb3fbd684cb6ce314f90eb0fbff4d2a" => :mojave
    sha256 "8e7ad3fdc5ba59c3860031e6d7603a3bce1bc9097058510802b0e204893a08c6" => :high_sierra
    sha256 "0915c385d235de872eb5f83c0acf4adca7f7b539713d4efceb3f631c995f7a5b" => :sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "api/BamWriter.h"
      using namespace BamTools;
      int main() {
        BamWriter writer;
        writer.Close();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/bamtools", "-L#{lib}",
                    "-lbamtools", "-lz", "-o", "test"
    system "./test"
  end
end
