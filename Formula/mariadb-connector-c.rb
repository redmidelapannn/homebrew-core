class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.2/mariadb-connector-c-3.0.2-src.tar.gz"
  sha256 "518d14b8d77838370767d73f9bf1674f46232e1a2a34d4195bd38f52a3033758"
  bottle do
    sha256 "a25c99ec96338dba978b8c53d346ff1b5f6ffaa47d55f050f677d8333806aad7" => :high_sierra
    sha256 "9ec27d8aa749028c83ae4d03f93b00880d78f03d9da0b47d7c6ccf464f26fc6e" => :sierra
    sha256 "854246f75a9d945d20d6ce055b52b54e87393614e32d8bc0d473195ea2490a2c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
