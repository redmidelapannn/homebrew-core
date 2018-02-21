class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.5.0.tar.gz"
  sha256 "03b8362c9172edbeb1e5970c996405cd2738e8274ba459e9b85359d6b838de20"
  revision 1

  bottle do
    sha256 "ac039d1a983f81892bd25cbd36de5fefe8399246a7d8bca92380b9322e6de521" => :high_sierra
    sha256 "14ceb15bd01e2cbdcc9ae2e2d9ec93a29185a18a440435d87e084bf2711a8303" => :sierra
    sha256 "2d7896229aaef933ae028ef1a0087186b2b4b9b1c2260eeb16e3e751cc1cb4bb" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-consensus"
  depends_on "libbitcoin-database"

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
      #include <bitcoin/blockchain.hpp>
      int main() {
        static const auto default_block_hash = libbitcoin::hash_literal("14508459b221041eab257d2baaa7459775ba748246c8403609eb708f0e57e74b");
        const auto block = std::make_shared<const libbitcoin::message::block>();
        libbitcoin::blockchain::block_entry instance(block);
        assert(instance.block() == block);
        assert(instance.hash() == default_block_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-L#{lib}", "-L#{libexec}/lib",
                    "-lbitcoin", "-lbitcoin-blockchain", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
