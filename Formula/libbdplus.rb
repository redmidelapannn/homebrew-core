class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://download.videolan.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  sha256 "a631cae3cd34bf054db040b64edbfc8430936e762eb433b1789358ac3d3dc80a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e0c7f40d9d05884f62bd17f02007d30e9fe2978f11e0eedabf1a470e360f5e97" => :catalina
    sha256 "f383d40cac371cb9d4e88e4ff2d74e108c1a165386a38700221367c90f1b026a" => :mojave
    sha256 "1592b81bcb9c64a778e62721c394d7443a0f8465d1967220b04aa1baa1672881" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libbdplus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbdplus/bdplus.h>
      int main() {
        int major = -1;
        int minor = -1;
        int micro = -1;
        bdplus_get_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lbdplus", "-o", "test"
    system "./test"
  end
end
