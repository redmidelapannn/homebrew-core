class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"

  bottle do
    cellar :any
    sha256 "36a30601a9d9727a3b162675e7b9a6863f10e7c4e9daf6c635e08aa317ea8642" => :catalina
    sha256 "2f2ba0ed72bf8b336ade111c2efdbb73bd33d44cd6cbd4fe953b030615dc598b" => :mojave
    sha256 "512bde387f2252ab4f8998a22baa16bddd140cd1cde3d578578dfa56c9b9c57d" => :high_sierra
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CCfits/CCfits>
      #include <iostream>
      int main()
      {
	      CCfits::FITS::setVerboseMode(true);
        std::cout <<"the answer is "<<CCfits::VTbyte<<std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lCCfits"
    assert_match /the answer is -11/, shell_output("./test")
  end
end
