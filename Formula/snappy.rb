class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.5.tar.gz"
  sha256 "c67d8d23387b1902ceff134af26e401d5412c510adeeabe6bb6b47c106b08e45"
  revision 1
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "6600ca7238b5b9972df3ac8a39510c77c6d63605830d78911fba81b7121e83e1" => :sierra
    sha256 "ea167fd29ddf8ebe2185eff8516ed9f5ff0390a51836b220c61a0d73022f388b" => :el_capitan
    sha256 "cddfd368e28ae5d25c284cd9044171260e1a6cf4665c12a87f67b15209398744" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Make sure we install a libsnappy.1.dylib symlink
  # PR from 6 Jul 2017 "Set both VERSION and SOVERSION for target snappy"
  patch do
    url "https://github.com/google/snappy/pull/45.patch?full_index=1"
    sha256 "ca9fd0bb48d14d1b59c402addb68a9b184ca680525a9b4acceaf7a614fd24f50"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <snappy.h>
      #include <string>
      using namespace std;
      using namespace snappy;

      int main()
      {
        string source = "Hello World!";
        string compressed, decompressed;
        Compress(source.data(), source.size(), &compressed);
        Uncompress(compressed.data(), compressed.size(), &decompressed);
        assert(source == decompressed);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end
