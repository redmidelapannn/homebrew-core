class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.5.0.tar.gz"
  sha256 "37ef8d572fb7400565655501ffdea5d07a1de10f3d9fa823d33e2bf68ef8c3ce"
  revision 1

  bottle do
    sha256 "a57017402cb482dbb3a5287f45d9c2cc1228c8ed01e538a200bd9f39012b66ac" => :high_sierra
    sha256 "aee127596bae4f50175c8c150226fd6280b304b29680c41c1b76322e6368399c" => :sierra
    sha256 "5644186821fece34be5159b46a54ef6be9e72b32dfc90bf0a2e20c36f3248b89" => :el_capitan
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
