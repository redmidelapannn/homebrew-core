class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.5.0.tar.gz"
  sha256 "37ef8d572fb7400565655501ffdea5d07a1de10f3d9fa823d33e2bf68ef8c3ce"
  revision 3

  bottle do
    sha256 "7aaaca14d6ec4eeafa1c780ad5cc79e91bfe55bf756479e8e3f69db2e9f2f006" => :mojave
    sha256 "1422408f0bfb203f9e6083deb2c62b588ca8326506be480723ed3d540ecfe324" => :high_sierra
    sha256 "aea6ad4ba4ecee1492c846a4690eb588b0797435ede9666798363d021e62a444" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bs"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/server.hpp>
      int main() {
          libbitcoin::server::message message(true);
          assert(message.secure() == true);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-server", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
