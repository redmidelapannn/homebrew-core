class Cxxtest < Formula
  desc "xUnit-style unit testing framework for C++"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "dcd913cc919f21f6bd16c44f3418d1318c6534bc2f4eb88a620e6cb67ec1ecaa" => :mojave
    sha256 "dcd913cc919f21f6bd16c44f3418d1318c6534bc2f4eb88a620e6cb67ec1ecaa" => :high_sierra
    sha256 "f4f3b011b7683b38b79c2fe33bd7f937cac07c4c37b94bcc85f130949e9048df" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{xy}/site-packages"

    cd "./python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    include.install "cxxtest"
    doc.install Dir["doc/*"]
  end

  test do
    testfile = testpath/"MyTestSuite1.h"
    testfile.write <<~EOS
      #include <cxxtest/TestSuite.h>

      class MyTestSuite1 : public CxxTest::TestSuite {
      public:
          void testAddition(void) {
              TS_ASSERT(1 + 1 > 1);
              TS_ASSERT_EQUALS(1 + 1, 2);
          }
      };
    EOS

    system bin/"cxxtestgen", "--error-printer", "-o", testpath/"runner.cpp", testfile
    system ENV.cxx, "-o", testpath/"runner", testpath/"runner.cpp"
    system testpath/"runner"
  end
end
