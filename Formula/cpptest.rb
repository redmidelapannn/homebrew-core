class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.2/cpptest-1.1.2.tar.gz"
  sha256 "9e4fdf156b709397308536eb6b921e3aea1f463c6613f9a0c1dfec9614386027"

  bottle do
    cellar :any
    rebuild 2
    sha256 "10800c4a4b963dddfa07bc0a95b79a9d4775d6f83165faa506f154ea92c83892" => :sierra
    sha256 "bb84b8d2d15e4c77cda3bffb3c2802e2ce402d6c44d1740d7e56d31b40206df0" => :el_capitan
    sha256 "04cd2927f02b11aef2b659d169b6c30f6580a0d3ec320b179a78896fc5b08092" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <cpptest.h>

      class TestCase: public Test::Suite
      {
      public:
        TestCase() { TEST_ADD(TestCase::test); }
        void test() { TEST_ASSERT(1 + 1 == 2); }
      };

      int main()
      {
        TestCase ts;
        Test::TextOutput output(Test::TextOutput::Verbose);
        assert(ts.run(output));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcpptest", "-o", "test"
    system "./test"
  end
end
