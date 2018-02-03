class Cxxtest < Formula
  desc "xUnit-style unit testing framework for C++"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ffd073cf94fbfff931d6607b11e6df20570a72979858983e98572b5223286e12" => :high_sierra
    sha256 "ffd073cf94fbfff931d6607b11e6df20570a72979858983e98572b5223286e12" => :sierra
    sha256 "ffd073cf94fbfff931d6607b11e6df20570a72979858983e98572b5223286e12" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
