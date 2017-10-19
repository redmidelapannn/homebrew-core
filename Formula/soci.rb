class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-3.2.3/soci-3.2.3.zip"
  sha256 "ab0f82873b0c5620e0e8eb2ff89abad6517571fd63bae4bdcac64dd767ac9a05"

  bottle do
    rebuild 1
    sha256 "71fefcedc68689985a1a5ce70814e9556e12492cb6373c923e9d0e49df267e5e" => :high_sierra
    sha256 "ea4db7c3371d9f66a81e3f65f940649c59fb16033a14f191e6edb05bd3e38cb2" => :sierra
    sha256 "fa5b63500ad1abcd3d8292dfca39836771bebb931aef57b83b95fadea0ea8425" => :el_capitan
  end

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  depends_on "cmake" => :build
  depends_on "boost" => [:build, :optional]
  depends_on "sqlite" if MacOS.version <= :snow_leopard

  def translate(a)
    (a == "pg") ? "postgresql" : a
  end

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[.. -DWITH_SQLITE3:BOOL=ON]

    %w[boost mysql oracle odbc pg].each do |a|
      bool = build.with?(a) ? "ON" : "OFF"
      args << "-DWITH_#{translate(a).upcase}:BOOL=#{bool}"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end
end
