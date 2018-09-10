class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://github.com/SOCI/soci/archive/3.2.3.tar.gz"
  sha256 "1166664d5d7c4552c4c2abf173f98fa4427fbb454930fd04de3a39782553199e"

  bottle do
    rebuild 1
    sha256 "0ef48b17911e885691dae7acad8f6085b85aec719b6d183eaa2c51cd2ddb9650" => :mojave
    sha256 "8eca32f34e057891de14e7c024d6ade797e0a796a4b90a2fa5d78a8c15ab825d" => :high_sierra
    sha256 "ad3b3bad49e14a21fd908dbabf30e7553bbb65f1f4e55f1aff6d16a1bb44d689" => :sierra
    sha256 "8b356d5c7ba6ef1554b5fd271ced0a024166b7b5b051eb1076750a53ea21e7e4" => :el_capitan
  end

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  depends_on "cmake" => :build
  depends_on "boost" => [:build, :optional]
  depends_on "sqlite" if MacOS.version <= :snow_leopard
  depends_on "mysql-client" if build.with?("mysql")

  patch do
    url "https://github.com/SOCI/soci/commit/165737c4be7d6c9acde92610b92e8f42a4cfe933.diff"
    sha256 "29e90baac2d8fa3412485352b0c0ce393cd3a482b951268833ae1dc32336ae0e"
  end

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[../src -DWITH_SQLITE3:BOOL=ON]
    args += %W[-DMYSQL_DIR=#{Formula["mysql-client"].opt_prefix}] if build.with?("mysql")

    %w[boost mysql oracle odbc pg].each do |arg|
      arg_var = (arg == "pg") ? "postgresql" : arg
      bool = build.with?(arg) ? "ON" : "OFF"
      args << "-DWITH_#{arg_var.upcase}:BOOL=#{bool}"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end
end
