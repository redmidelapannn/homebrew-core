class MariadbConnectorOdbc < Formula
  desc "MariaDB Standardized database driver"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "http://mariadb.mirror.triple-it.nl/connector-odbc-3.0.1/mariadb-connector-odbc-3.0.1-beta-src.tar.gz"
  sha256 "03e3fbf5f3957c88bc89c45a8396c1aabf88ec86f21e5e6dd0c6ad09e30389aa"

  bottle do
    sha256 "5fe8d83fb3ddf2933b5e759e3a92034daab8df190747b3641a6fb3b310189f53" => :high_sierra
    sha256 "0fb7e1f6745b75c32d1edb204f305a3ba750c27f8032541337026994043dd2f2" => :sierra
    sha256 "f7caf2aaedefb8935c2660c3ad34a5753d7aaadf0f1d212c79d707981a9ae7bf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl"
  depends_on "unixodbc"

  def install
    system "cmake", ".", "-DWITH_UNIXODBC=1", "-DMARIADB_FOUND=1",
            "-DWITH_OPENSSL=1",
            "-DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include/",
            *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/libmaodbc.dylib")
    assert_equal "SUCCESS: Loaded #{lib}/libmaodbc.dylib", output.chomp
  end
end
