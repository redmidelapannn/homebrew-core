class MysqlConnectorC < Formula
  desc "MySQL database connector for C applications"
  homepage "https://dev.mysql.com/downloads/connector/c/"
  url "https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.11-src.tar.gz"
  sha256 "c8664851487200162b38b6f3c8db69850bd4f0e4c5ff5a6d161dbfb5cb76b6c4"

  bottle do
    rebuild 1
    sha256 "c08b75ff60c2a08b97e6cbe4ef39b8aa691478ad6ae071f0a8c3d1a2ada8ef04" => :high_sierra
    sha256 "24dce9e886d3fd2959116449dfa953ed10a11a42fcf07b62b454037cb3652f9b" => :sierra
    sha256 "0abd64f7878635e5f22b59ec35d7f2f29206e419d7831b97537a68619fd5ecb8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "both install MySQL client libraries"
  conflicts_with "mysql-cluster",
    :because => "both install `bin/my_print_defaults`"

  def install
    system "cmake", ".", "-DWITH_SSL=system", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match include.to_s, shell_output("#{bin}/mysql_config --cflags")
  end
end
