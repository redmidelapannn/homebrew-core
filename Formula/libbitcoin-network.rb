class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.5.0.tar.gz"
  sha256 "e065bd95f64ad5d7b0f882e8759f6b0f81a5fb08f7e971d80f3592a1b5aa8db4"

  bottle do
    rebuild 1
    sha256 "3391ce54e17ec45b634c8db121b1733459acef418e032e15d87836ea284105c6" => :mojave
    sha256 "039f162c5006b338e06e94bc094c43eaf1116646c7d03221fbc5c028f090875d" => :high_sierra
    sha256 "65d143767df46d7566ec3bc9fae78c96d51ba922fc9e72ae00c1b6e1f7e3ad13" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/network.hpp>
      int main() {
        const bc::network::settings configuration;
        bc::network::p2p network(configuration);
        assert(network.top_block().height() == 0);
        assert(network.top_block().hash() == bc::null_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-network",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
