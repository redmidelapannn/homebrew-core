class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.2.7.tar.gz"
  sha256 "be91c6bf304732b2d2d65c7ec57b8bf3daf1748c2ee932b852fd830db328ecc7"
  revision 1
  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9b3bed8e46b3cb4c638a9e89f94a7d35ee4da599225dc4aea2251606321ae173" => :sierra
    sha256 "50b18f735d79268720e68b60931fb40279d6e5ebff0922344e8915508c7887ce" => :el_capitan
    sha256 "b07cc03ef333c906004043aeff754460cec6433c987c0b5d9b8ea729493bee53" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "snappy"
  depends_on "boost" => :optional

  def install
    args = std_cmake_args + %w[. -DBUILD_TESTS=ON]
    args << "-DWITH_BOOST_IOSTREAMS=1" if build.with? "boost"
    system "cmake", *args
    system "make", "all", "test", "install"
  end

  test do
    (testpath/"testsnappystream.cxx").write <<-EOS.undent
      #include <iostream>
      #include <fstream>
      #include <iterator>
      #include <algorithm>
      #include <snappystream.hpp>

      int main()
      {
        { std::ofstream ofile("snappy-file.dat");
          snappy::oSnappyStream osnstrm(ofile);
          std::cin >> std::noskipws;
          std::copy(std::istream_iterator<char>(std::cin), std::istream_iterator<char>(), std::ostream_iterator<char>(osnstrm));
        }
        { std::ifstream ifile("snappy-file.dat");
          snappy::iSnappyStream isnstrm(ifile);
          isnstrm >> std::noskipws;
          std::copy(std::istream_iterator<char>(isnstrm), std::istream_iterator<char>(), std::ostream_iterator<char>(std::cout));
        }
      }
    EOS
    system ENV.cxx, "testsnappystream.cxx", "-lsnappy", "-L#{lib}", "-lsnappystream", "-o", "testsnappystream"
    system "./testsnappystream < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
