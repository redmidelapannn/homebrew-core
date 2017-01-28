class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/releases/download/1.1.4/snappy-1.1.4.tar.gz"
  sha256 "134bfe122fd25599bb807bb8130e7ba6d9bdb851e0b16efcb83ac4f5d0b70057"

  bottle do
    cellar :any
    sha256 "cd88be1dad7f60ddbaea2ee3ad2886165108c2b944bebc83191e48e17de9820b" => :sierra
    sha256 "3afcebfc5b7d6c6b5f6bf3deaae31eb18901d6e2a678e93ce2f8b2d0def1f5a7" => :el_capitan
    sha256 "b213966add3c3acdce7f612135d9d4a0f1ef3b70ab2bd254e775b27968e14e7a" => :yosemite
    sha256 "e05b8764ffbf52ef4505471f3db46b1373d4c91be7dfb64bf29a6aff4a454f5e" => :mavericks
    sha256 "7afb5461d7424be580c7f3b1f04e2145775b21e571a277dae1f604f11c544363" => :mountain_lion
  end

  head do
    url "https://github.com/google/snappy.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize if build.stable?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
