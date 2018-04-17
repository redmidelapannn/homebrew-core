class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2832caa3729191331410b8857824653a9ca68650a5d4c1f1ee4c359891191a93" => :high_sierra
    sha256 "84b16f782e3a4fa9b87b951bccdc603f56529eab3f3213da37c4988d195e22c1" => :sierra
    sha256 "32adb8bdf59e2c43ae026e74459b70e478fefb02d91b8a9201812d85c3d87d5d" => :el_capitan
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
