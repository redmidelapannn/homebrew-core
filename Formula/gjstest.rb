class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 12
  head "https://github.com/google/gjstest.git"

  bottle do
    rebuild 1
    sha256 "6c50f5c0287716d53486b0d01879001faa00cceba18bf2e8a2618bc0abc50b6e" => :high_sierra
    sha256 "2129dd6fdf4c931cc398c914760d23eba9190d633a69502f93b10725c76673db" => :sierra
    sha256 "14b781a30e57d643c09093c3dc8a752710bec5a960c504980fd392745af02ca2" => :el_capitan
  end

  depends_on :macos => :mavericks

  depends_on "gflags"
  depends_on "glog"
  depends_on "libxml2"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "v8"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"sample_test.js").write <<~EOS
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOS

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end
