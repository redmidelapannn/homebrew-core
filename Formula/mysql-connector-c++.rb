class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-8.0.11-src.tar.gz"
  sha256 "1355589bfd7abe14f56627eb8dc7544ed5810ecc71d7691186707a053156e944"

  bottle do
    cellar :any
    sha256 "ae59610e0ef47ec6570482c26629e5c81fd0467c2ec4b99b7322772bccdba30d" => :high_sierra
    sha256 "2f63b6e7392810828d88b39ac37e656efd7fb9a2848d0ff98db9e3d22a9a0801" => :sierra
    sha256 "2ac58c51a2b4460f4446457cb657fafcb6613a6a523ce26363ef42d3e5e1d81f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "mysql"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cppconn/driver.h>
      int main(void) {
        try {
          sql::Driver *driver = get_driver_instance();
        } catch (sql::SQLException &e) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", `mysql_config --include`.chomp, "-L#{lib}", "-lmysqlcppconn", "-o", "test"
    system "./test"
  end
end
