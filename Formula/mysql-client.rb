class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.18.tar.gz"
  sha256 "0eccd9d79c04ba0ca661136bb29085e3833d9c48ed022d0b9aba12236994186b"

  bottle do
    rebuild 1
    sha256 "d70f4526f4ca5dc37a943dcb52fb3bb41b33bc75737bb7e94e6aff2683e87467" => :catalina
    sha256 "c68b1f66654259ffbba51fd26500ff3188e6440209bd301cd8aa69e05f11ec26" => :mojave
    sha256 "22a91cc08c4901dadb101f156a142c9b4856ddb6b878f120e7f39eb5af57ed6e" => :high_sierra
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build

  # GCC is not supported either, so exclude for El Capitan.
  depends_on :macos => :sierra if DevelopmentTools.clang_build_version < 900

  depends_on "openssl@1.1"

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
