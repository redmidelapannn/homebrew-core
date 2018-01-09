class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-2.2.2/mariadb-connector-c-2.2.2-src.tar.gz/from/http%3A//ftp.hosteurope.de/mirror/archive.mariadb.org/?serve"
  sha256 "93f56ad9f08bbaf0da8ef03bc96f7093c426ae40dede60575d485e1b99e6406b"

  bottle do
    rebuild 1
    sha256 "379caac1bf68c73c4d7a4767da57aef47d9efa21b3a5600a5687a6dd064d4246" => :high_sierra
    sha256 "7074b53b21a478876e69e2b90868d9273b7238d7b461969f8bd233c21962f825" => :sierra
    sha256 "b6689fc04c330d1bfe23f89b417013179281c77dace8ab771a41f48230455511" => :el_capitan
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
