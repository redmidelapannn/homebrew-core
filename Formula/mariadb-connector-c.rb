class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.2/mariadb-connector-c-3.1.2-src.tar.gz"
  sha256 "156aa2de91fd9607fa6c638d23888082b6dd07628652697992bba6d15045ff5d"
  revision 1

  bottle do
    sha256 "6da34dc6bc12f9e4aef0720696be089c7a071cbff5ba0af80cd91ae1390830af" => :mojave
    sha256 "8cb155447edd9db4d3195a654270b7a6b14de6fe0b4b03b3ccbdc2e560ba69c0" => :high_sierra
    sha256 "369867f624dfd78f1c079be1051480037dcee6fc2e11e6b1b0b7556a82009939" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
