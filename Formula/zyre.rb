class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/releases/download/v2.0.0/zyre-2.0.0.tar.gz"
  sha256 "8735bdf11ad9bcdccd4c4fd05cebfbbaea8511e21376bc7ad22f3cbbc038e263"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d812868733801aa4db9f83c3bb1c66f48a66754d6f17f065e84a1e267b8f27d8" => :mojave
    sha256 "e791b216309160f36fb2fc4ba35fae67a753ffe1b8b0e46051af8942a1ae0afb" => :high_sierra
    sha256 "687a93277c2d8d53b6c8aa37a9659fb8958d678174e68a1b0ce63d0faaadef42" => :sierra
    sha256 "57cff19c5b862f3ab746227fbbff0b9c10cad6451e44868e063516f862b267bc" => :el_capitan
  end

  head do
    url "https://github.com/zeromq/zyre.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "czmq"
  depends_on "zeromq"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check-verbose"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zyre.h>

      int main()
      {
        uint64_t version = zyre_version ();
        assert(version >= 2);

        zyre_test(true);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lzyre", "-o", "test"
    system "./test"
  end
end
