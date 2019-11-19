class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.18.tar.gz"
  sha256 "0eccd9d79c04ba0ca661136bb29085e3833d9c48ed022d0b9aba12236994186b"

  bottle do
    rebuild 1
    sha256 "cd5cf86eb6efb2639fba45ae26eae50c5d5aaf010ce7454689aef91671b810ca" => :catalina
    sha256 "778658491846cc817f40a1997724c02745f9cb40268b329af373952bd9f9a1a9" => :mojave
    sha256 "3e0003cb77390694d549511464b1d8a832f5a58a7c9e2d1ccf8c6e221e157f9f" => :high_sierra
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build

  depends_on "openssl@1.1"

  depends_on :xcode => "9.0"

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
