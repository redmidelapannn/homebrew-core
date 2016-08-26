class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.05.0400.tar.gz"
  sha256 "c9fde1c104065e81813d79eb29bb7e715d64697bdda031ff01e40e3ad59e3ad3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a06e377dfc769c6f9518cd71ba615427cb30491814279b756309ecf42bc366f9" => :el_capitan
    sha256 "ed85103379c3991a3f46b4ed24b659483660a29cf6d355004a2325c868ee6482" => :yosemite
    sha256 "9171479896904b61e286c6d11bded835a87d7048daa3993aa5f11173461ec60e" => :mavericks
  end

  head do
    url "http://git.postgresql.org/git/psqlodbc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on :postgresql
  depends_on "unixodbc" => :recommended
  depends_on "libiodbc" => :optional

  def install
    if build.with?("libiodbc") && build.with?("unixodbc")
      odie "psqlodbc: --without-unixodbc must be specified when using --with-libiodbc"
    end

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--with-iodbc=#{Formula["libiodbc"].opt_prefix}" if build.with?("libiodbc")
    args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}" if build.with?("unixodbc")

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
