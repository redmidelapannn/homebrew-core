class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.5.0.tar.gz"
  sha256 "9deac6908489e2d59fb9f89c895c49b00e01902d5fdb661f67d4dbe45b22af76"
  revision 1

  bottle do
    cellar :any
    sha256 "5582eb11b35181840e66adcb3ed2c65ef6a469d633b12efc15b0b99f6c6896dc" => :mojave
    sha256 "c52ba86eaa76fe3b24156b072af9b271a909c458d0317af6d41e80ae08094ae1" => :high_sierra
    sha256 "76c049d8ae9ca24d26a7678184566b2992774b72df05363784b356a485b8e527" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

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
      #include <bitcoin/protocol.hpp>
      int main() {
        libbitcoin::protocol::zmq::message instance;
        instance.enqueue();
        assert(!instance.empty());
        assert(instance.size() == 1u);
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-protocol", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
