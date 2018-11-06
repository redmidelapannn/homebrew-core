class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.5.0.tar.gz"
  sha256 "e3a0a96155ca93aa6cba75789c18419f40686a69cbd40c77aa77ca84ccc43cab"
  revision 1

  bottle do
    rebuild 1
    sha256 "031a2794913b961e4d041ff665b1d5eca8d9a6d136e23ba1c1654274ac327244" => :mojave
    sha256 "c436e5e5ded621f3866fa47f172994730e2725d9c49dca887bdcc94b022f32a8" => :high_sierra
    sha256 "f1769e1e27db4f116b60132309783e08e6d7510cb895d329e5737ad17daade58" => :sierra
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-node",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
