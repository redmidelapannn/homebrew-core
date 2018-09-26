class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.5.0.tar.gz"
  sha256 "376ab5abd8d7734a8b678030b9e997c4b1922e422f6e0a185d7daa3eb251db93"
  revision 1

  bottle do
    sha256 "15da9128239737feeaecb32e8c3669c988b6977178f6904745e2da911bfa9b4a" => :mojave
    sha256 "2a60ed771e16c631ff1064a8600dea90b93356ff3075649e62bc4b8a37fd188b" => :high_sierra
    sha256 "b1886659bd211eb943d5df4a71aa8924aa13dd1377afbd3993dda91066dca5ae" => :sierra
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
      #include <bitcoin/database.hpp>
      using namespace libbitcoin::database;
      using namespace libbitcoin::chain;
      int main() {
        static const transaction tx{ 0, 0, input::list{}, output::list{ output{} } };
        unspent_outputs cache(42);
        cache.add(tx, 0, 0, false);
        assert(cache.size() == 1u);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-database", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
