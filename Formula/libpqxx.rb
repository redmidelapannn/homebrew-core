class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.5.tar.gz"
  sha256 "86921fdb0fe54495a79d5af2c96f2c771098c31e9b352d0834230fd2799ad362"
  revision 5

  bottle do
    cellar :any
    sha256 "56b6a42859f3bbe3a528e18355beae3f7ef1062cd782dcd9ee21ce630385a313" => :catalina
    sha256 "a42fb6c544b213a07b0fca25384b5e56d542f5f27164f31aee554010dfec7e3b" => :mojave
    sha256 "f43d8886cd8cadd7c3bedf665bbf6487519329163be6c276e917df07f85a65e4" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"
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
  end
end
