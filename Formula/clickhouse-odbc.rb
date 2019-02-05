class ClickhouseOdbc < Formula
  desc "ClickHouse ODBC driver"
  homepage "https://clickhouse.yandex"
  url "https://github.com/yandex/clickhouse-odbc.git",
      :tag      => "v1.0.0.20190201",
      :revision => "26c04d00ebfd0a09e074bc35fb9315a91075ad91"

  bottle do
    cellar :any
    sha256 "5bb9dbbafe68f61fbd3b890ef4fdd53c10a5794159999dc5706ac49f38b08f1d" => :mojave
    sha256 "1d3054c7501cd18df831c68a60875ee05a57e2815c1f883c701613055286b7a7" => :high_sierra
    sha256 "81181147e989207cfa28546f6c7f49ba4f1cc31ba81346588eaddab044e181a2" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libiodbc" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  def install
    args = std_cmake_args
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "cmake", "--build", "."
      system "ctest", "-V"
      # system "ninja", "install" # installs too many trash
      lib.install "driver/libclickhouseodbc.dylib"
      lib.install "driver/libclickhouseodbcw.dylib"
    end
    lib.install_symlink "#{lib}/libclickhouseodbc.dylib" => "libclickhouseodbc.so"
    lib.install_symlink "#{lib}/libclickhouseodbcw.dylib" => "libclickhouseodbcw.so"
  end

  test do
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("otool -L #{lib}/libclickhouseodbc.so")
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("otool -L #{lib}/libclickhouseodbcw.so")
    # TODO: fix build with unixodbc and enable:
    # output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbc.so")
    # assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbc.so\n", output
    # output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libclickhouseodbcw.so")
    # assert_equal "SUCCESS: Loaded #{lib}/libclickhouseodbcw.so\n", output
  end
end
