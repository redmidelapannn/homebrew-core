class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.4.tar.gz"
  sha256 "91a295d9e06fc36db5d993970aa1928e053a57ec03bf6284a1c534844ed35ed3"
  revision 3

  bottle do
    cellar :any
    sha256 "42a7b14e48060e0480179ae2383542eda0a95a03222b7542dd80babd341f29f0" => :mojave
    sha256 "b68bc4b41b49fc86b1b69796712ca83a35c7b0e7f9410268ceae529401bba89e" => :high_sierra
    sha256 "b12c3439ee2bb5b595bf772210f3b1e9f975541e53b8067cbee1ef4c9429e95e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "postgresql"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"

    # `pg_config` uses Cellar paths not opt paths
    postgresql_include = Formula["postgresql"].opt_include.realpath.to_s
    assert_match postgresql_include, (lib/"pkgconfig/libpqxx.pc").read,
                 "Please revision bump libpqxx."
  end
end
