class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 9
  head "https://github.com/google/gjstest.git"

  bottle do
    rebuild 1
    sha256 "36fcc366a0494b4bc71e35126c75910e64e66b4ae433fa64046246de9be48507" => :sierra
    sha256 "692dfbdc74f8e06ad37fe3178b7f407c3a04bd4b4b257ed05ce7db694ca40eaa" => :el_capitan
    sha256 "15045fe87e40e3facb8d7a206648e66972439205fbfdb994f439900140d2516c" => :yosemite
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
