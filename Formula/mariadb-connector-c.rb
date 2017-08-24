class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-2.2.2/mariadb-connector-c-2.2.2-src.tar.gz"
  sha256 "93f56ad9f08bbaf0da8ef03bc96f7093c426ae40dede60575d485e1b99e6406b"

  bottle do
    rebuild 1
    sha256 "3b1cb6fa9ddb8cff7c3af3a8c3be07bf8c233bf8d425df6f348c048855d9cfac" => :sierra
    sha256 "bf2322fa11a3d21197beac8c017110bdf40663f01756618acbe9a2b051b84330" => :el_capitan
    sha256 "282cf1830d1d6c2ff2a848ce2626b52d682cab07c845a9bcc9bd06ee26bc51bf" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "percona-server",
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
