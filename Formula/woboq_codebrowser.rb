class WoboqCodebrowser < Formula
  desc "Generate HTML from C++ Code"
  homepage "https://code.woboq.org/"
  url "https://github.com/woboq/woboq_codebrowser/archive/2.1.tar.gz"
  sha256 "f7c803260a9a79405c4c2c561443c49702811f38dcf1081238ef024a6654caa0"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "5ebc9cdeb82be2cd9f15b03391de31ef5503ab15a03d90b8cd9b5140ac5f45ba" => :mojave
    sha256 "61684930dc32c3db1c3fc8d663793bcd4cce3c7dd6a1bd2127efa10a4a43045e" => :high_sierra
    sha256 "adc0abaa13d9f4565210ce2e3a354f107d464d4f58c00e1eab50bfdd00fe7a25" => :sierra
    sha256 "f53ec09e3a1da310d6ccb7f77860c885b0c92483a8a245034b399f81a204dd79" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    args = std_cmake_args + %W[
      -DLLVM_CONFIG_EXECUTABLE=#{Formula["llvm"].opt_bin}/llvm-config
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ]
    system "cmake", ".", *args
    system "make"
    bin.install "indexgenerator/codebrowser_indexgenerator",
                "generator/codebrowser_generator"
    prefix.install "data"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
      printf(\"hi!\");
      }
    EOS
    system "#{bin}/codebrowser_generator", "-o=#{testpath}", "-p",
                                           "test:#{testpath}",
                                           "#{testpath}/test.c",
                                           "--", "clang", "#{testpath}/test.c"

    assert_predicate testpath/"test/test.c.html", :exist?
    assert_predicate testpath/"refs/printf", :exist?
    assert_predicate testpath/"include/sys/stdio.h.html", :exist?
    assert_predicate testpath/"fnSearch", :exist?
    assert_predicate testpath/"fileIndex", :exist?
  end
end
