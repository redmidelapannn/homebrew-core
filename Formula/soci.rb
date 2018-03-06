class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-3.2.3/soci-3.2.3.zip"
  sha256 "ab0f82873b0c5620e0e8eb2ff89abad6517571fd63bae4bdcac64dd767ac9a05"

  bottle do
    rebuild 1
    sha256 "3f082affe2519ebb1ab60070722217f249a16b12431070b021f4eeaf71a6e7de" => :high_sierra
    sha256 "174fd5b3530548cd4f2bea89da34c8cbfb9e5f7bbdd642731a2aadf0b08e2d05" => :sierra
    sha256 "a3c942acf5fc54d8e95bc7bfcc375bc86ead8faf43a738f990c42f28b32d31f0" => :el_capitan
  end

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  depends_on "cmake" => :build
  depends_on "boost" => [:build, :optional]
  depends_on "sqlite" if MacOS.version <= :snow_leopard

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[.. -DWITH_SQLITE3:BOOL=ON]

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
