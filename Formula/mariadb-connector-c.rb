class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.5/mariadb-connector-c-3.1.5-src.tar.gz"
  sha256 "a9de5fedd1a7805c86e23be49b9ceb79a86b090ad560d51495d7ba5952a9d9d5"

  bottle do
    rebuild 1
    sha256 "2c2a550d36eb4783ae1a08041eb01f8c48318502de50fa398739ffd178e5bf94" => :catalina
    sha256 "2d172141c288c2daccb54da7a9d7615e2ead5e5cfbdb12549922cf89f170cd52" => :mojave
    sha256 "c2ca2fd10ec9e74fb4a602e0b4f5ac907c02ee4b11f86ae3fa3b3fc1eaed6ed1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mariadb",
                 :because => "both install mariadb_config"

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
