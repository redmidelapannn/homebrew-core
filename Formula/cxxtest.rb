class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "65a94f27723bdc062b26f44297aca4db00bb09c2f11fda8ac4326da6dc49b59c" => :catalina
    sha256 "fbe63eb61e1bf6e49ba48246cde6aed027e617662527a9d2b259d8ca298db219" => :mojave
    sha256 "2e65e1d1c25dcc2f44b47a3f58696eae2fa84c5f4f502d1c1fe88d0f1b02cbc0" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install_and_link buildpath/"python"

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
