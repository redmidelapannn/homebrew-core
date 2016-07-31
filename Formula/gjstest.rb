class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 4

  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "fbd395ad8fb64f5c7667b6964135c7b09880f3e7b81f7fb4e173858c2690dc8b" => :el_capitan
    sha256 "4503c9aec27ddfda744a21aed11a13f146977c117f03161d2bc8791d6f47538a" => :yosemite
    sha256 "9bcb96b7df2a2f79077769647625de6ee8639a497771c1e31b1260aef301ec4d" => :mavericks
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
    (testpath/"sample_test.js").write <<-EOF
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOF

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end
