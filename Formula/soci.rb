class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-3.2.3/soci-3.2.3.zip"
  sha256 "ab0f82873b0c5620e0e8eb2ff89abad6517571fd63bae4bdcac64dd767ac9a05"

  bottle do
    rebuild 1
    sha256 "84299903a024496aa40965d27f828724ac936842fdf8d6755a0b2007be904fec" => :high_sierra
    sha256 "c4da8eccf57339de9cc1d226956a10d2ecfb5bd8a65b2fdf29149eba309a0f52" => :sierra
    sha256 "43398faa9b9ad993fef080f2c8ce59d8f20bbc6f8e7b800a4a1391c1d986f165" => :el_capitan
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
