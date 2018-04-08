class Cxxtest < Formula
  desc "xUnit-style unit testing framework for C++"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "39acd580087caf84ed99af51ff53ec005d9b7b9b1104f6db78168c96dacc7dba" => :high_sierra
    sha256 "39acd580087caf84ed99af51ff53ec005d9b7b9b1104f6db78168c96dacc7dba" => :sierra
    sha256 "39acd580087caf84ed99af51ff53ec005d9b7b9b1104f6db78168c96dacc7dba" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"

    cd "./python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

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
