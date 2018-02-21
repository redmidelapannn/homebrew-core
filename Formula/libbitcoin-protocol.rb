class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.5.0.tar.gz"
  sha256 "9deac6908489e2d59fb9f89c895c49b00e01902d5fdb661f67d4dbe45b22af76"

  bottle do
    cellar :any
    sha256 "5d90833384377a333d777d877e22db39954ab87316bf2d518a395d69fa554f30" => :high_sierra
    sha256 "e2f61cf47bf8fbab60d851dd5e8369e796065edc63537a49dac4e79953ca5494" => :sierra
    sha256 "309b5900b72b225d0585c8197b60a5335cfa0121f41121f48d960a6f44fb50cc" => :el_capitan
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
        bc::protocol::zmq::message instance;
        instance.enqueue();
        assert(!instance.empty());
        assert(instance.size() == 1u);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-protocol", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
