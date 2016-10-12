class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "http://www.gecode.org/"
  url "http://www.gecode.org/download/gecode-4.4.0.tar.gz"
  sha256 "b45783cc8d0d5dbbd3385a263a2199e6ad7f9a286e92607de81aa0c1105769cb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3c3ef1090810755db7e0e3a5f2b6c85086b40e06414087bfa354107a1c2f3dfe" => :sierra
    sha256 "d5e33ca07773fae6828bfd5c51cb3fcbcea3a0a2ddcbfe3c22af7845a7553681" => :el_capitan
    sha256 "fc5c888f81038982298f619595ffcd561939d45a97d42d1194f15f54f85abca7" => :yosemite
  end

  depends_on "qt5" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
    ]
    ENV.cxx11
    if build.with? "qt5"
      args << "--enable-qt"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    else
      args << "--disable-qt"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gecode/driver.hh>
      #include <gecode/int.hh>
      #if defined(GECODE_HAS_QT) && defined(GECODE_HAS_GIST)
      #include <QtGui/QtGui>
      #if QT_VERSION >= 0x050000
      #include <QtWidgets/QtWidgets>
      #endif
      #endif
      using namespace Gecode;
      class Test : public Script {
      public:
        IntVarArray v;
        Test(const Options& o) : Script(o) {
          v = IntVarArray(*this, 10, 0, 10);
          distinct(*this, v);
          branch(*this, v, INT_VAR_NONE(), INT_VAL_MIN());
        }
        Test(bool share, Test& s) : Script(share, s) {
          v.update(*this, share, s.v);
        }
        virtual Space* copy(bool share) {
          return new Test(share, *this);
        }
        virtual void print(std::ostream& os) const {
          os << v << std::endl;
        }
      };
      int main(int argc, char* argv[]) {
        Options opt("Test");
        opt.iterations(500);
      #if defined(GECODE_HAS_QT) && defined(GECODE_HAS_GIST)
        Gist::Print<Test> p("Print solution");
        opt.inspect.click(&p);
      #endif
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    EOS

    args = %W[
      -std=c++11
      -I#{HOMEBREW_PREFIX}/opt/qt5/include
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -L#{lib}
      -o test
    ]
    if build.with? "qt5"
      args << "-lgecodegist"
    end
    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
