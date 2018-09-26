class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.5.0.tar.gz"
  sha256 "e3a0a96155ca93aa6cba75789c18419f40686a69cbd40c77aa77ca84ccc43cab"
  revision 2

  bottle do
    sha256 "d81b4c77e0b7d9a125009586a640cc97eddad5d9d38005d6208b46d876ce8262" => :mojave
    sha256 "8b2970a5b1f82ae01a2392b6832a31d4f27d0a631ba7b00981b47ca805682020" => :high_sierra
    sha256 "ebf0fecaa906a95389c3efca383392331246233a2bf5165dad5d24c60f28ca78" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-blockchain"
  depends_on "libbitcoin-network"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bn"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/node.hpp>
      int main() {
        libbitcoin::node::settings configuration;
        assert(configuration.sync_peers == 0u);
        assert(configuration.sync_timeout_seconds == 5u);
        assert(configuration.refresh_transactions == true);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-lbitcoin", "-lbitcoin-node", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
