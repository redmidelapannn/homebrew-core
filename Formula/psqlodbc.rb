class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.03.0000.tar.gz"
  sha256 "0d2ff2d10d9347ef6ce83c7ca24f4cb20b4044eeef9638c8ae3bc8107e9e92f8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3d522837a9efc2ca2a93dea12c1721fb79cff12c6dc301c8f61901ada93fa146" => :mojave
    sha256 "4c61ed34b3e05d015d4320adde3d05aeebaa73a26744e84ede516aef49057cec" => :high_sierra
    sha256 "5717f194da36f718ef21fa3dce4c3590bfe7cd0a14f3cfb1c91d5070ed2455c5" => :sierra
    sha256 "3c03283b932a91582eb1bf0263ea8b1c3817615af4a276e5d98d5c0ae6a1a49c" => :el_capitan
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "postgresql"
  depends_on "unixodbc"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
