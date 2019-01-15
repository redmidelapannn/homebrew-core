class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/release-6.1.0.tar.gz"
  sha256 "e02e48aa90870a25509de2aeb99662d8b51c1de60cae4a34a78d4b6e9321e7ae"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4188ffb43a64066c96504cdc9211d82bbcc4b1271840ca20fa81d432d04bc3db" => :mojave
    sha256 "7164a18278fae334c1d0986d868e33d9bae9cf9ea404e5f4af2196981a0f9f51" => :high_sierra
    sha256 "5679eea7a0b80304bd453d2515a5e27ee1c1f81e7a8fdcddce61b1eaf636ca5d" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --disable-qt
    ]
    ENV.cxx11
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gecode/driver.hh>
      #include <gecode/int.hh>
      using namespace Gecode;
      class Test : public Script {
      public:
        IntVarArray v;
        Test(const Options& o) : Script(o) {
          v = IntVarArray(*this, 10, 0, 10);
          distinct(*this, v);
          branch(*this, v, INT_VAR_NONE(), INT_VAL_MIN());
        }
        Test(Test& s) : Script(s) {
          v.update(*this, s.v);
        }
        virtual Space* copy() {
          return new Test(*this);
        }
        virtual void print(std::ostream& os) const {
          os << v << std::endl;
        }
      };
      int main(int argc, char* argv[]) {
        Options opt("Test");
        opt.iterations(500);
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    EOS

    args = %W[
      -std=c++11
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -L#{lib}
      -o test
    ]
    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
