class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.5.tar.gz"
  sha256 "36fcf8439ac7f7cc68b21e95b20e921ece4487cda1cc1d09b798a84e7cb3a4b7"
  revision 1

  bottle do
    cellar :any
    sha256 "07b3cf28ee7ef93d7c8b8e69c434007fca5c3e37201390ae1c462fc8cde3bc20" => :mojave
    sha256 "666735f9928adc60231b3bf5c9e2a51e1ad530adea4dc41fcaa764e24e3a2e89" => :high_sierra
    sha256 "5ce0e12e47211450cdb62f1d53cc36850c375f28843db54e799ac186ca32069e" => :sierra
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
