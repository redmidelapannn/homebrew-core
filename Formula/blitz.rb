class Blitz < Formula
  desc "C++ class library for scientific computing"
  homepage "https://blitz.sourceforge.io"
  url "https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz"
  sha256 "804ef0e6911d43642a2ea1894e47c6007e4c185c866a7d68bad1e4c8ac4e6f94"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6efe5613a84b04273eae13a4c23318a40943bde136858ad25bfe75d4f60602c2" => :high_sierra
    sha256 "b161fac93c141506c3578975b753acaf86e306e67cde245d6c2dc844afbb44ff" => :sierra
    sha256 "c2ce51d53e0dba6c6b4d99038db2c0064e2f325bc344fdb403743567a63dd4be" => :el_capitan
  end

  head do
    url "https://github.com/blitzpp/blitz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "python2" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.cpp").write <<~EOS
      #include <blitz/array.h>
      #include <cstdlib>
      using namespace blitz;
      int main(){
        Array<float,2> A(3,1);
        A = 17, 2, 97;
        cout << "A = " << A << endl;
        return 0;}
    EOS
    system ENV.cxx, "testfile.cpp", "-o", "testfile"
    output = shell_output("./testfile")
    var = "/A\ =\ \(0,2\)\ x\ \(0,0\)\n\[\ 17\ \n\ \ 2\ \n\ \ 97\ \]\n\n/"
    assert_match output, var
  end
end
