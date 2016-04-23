class Libsecp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1 "
  homepage "https://github.com/bitcoin/secp256k1"
  url "https://github.com/bitcoin/secp256k1.git",
    :revision => "7b549b1abc06fe1c640014603346b85c8bc83e0b"
  version "0.1"

  bottle do
    cellar :any
    sha256 "a6f7aa00a74e369dce3e11675f50f7e064d4e78129d77891b7bb0c3148481b19" => :el_capitan
    sha256 "e3bb8454640533130cc11d2b5892b2334412970a81502508528c48c350d771b7" => :yosemite
    sha256 "c8a7aa8df78f75f99b5aef85c6d6628a2266a56b219ef100dad12e78593dd732" => :mavericks
  end

  option :universal
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp" => :optional

  def install
    if build.universal?
      ENV.universal_binary
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <secp256k1.h>

      int main()
      {
        secp256k1_context *ctx =
          secp256k1_context_create(SECP256K1_CONTEXT_VERIFY |
                                   SECP256K1_CONTEXT_SIGN);
        if (ctx) {
          secp256k1_context_destroy(ctx);
          return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsecp256k1", "-o", "test"
    system "./test"
  end
end
