class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.18.tar.gz"
  sha256 "0eccd9d79c04ba0ca661136bb29085e3833d9c48ed022d0b9aba12236994186b"

  bottle do
    rebuild 1
    sha256 "ee6d8777c68d7a1d3937642457e81680a355a79c378ca25e96ef3d3f489887be" => :catalina
    sha256 "1f9f0f1ba6e033e61ace6b9c15e8a75a6fafc91d07b9e10fd2cae910af31123b" => :mojave
    sha256 "140afce28677e62aef77084c10efacc023a1e5d7e087a346c0e7af30d7980c75" => :high_sierra
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build

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
