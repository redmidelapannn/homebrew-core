class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-3.4.9.tar.bz2"
  sha256 "2b1124db2d937ed6666525b9fc60a5dd55cb82f4cae58116cb986de53faa5dff"

  bottle do
    sha256 "4777746250d5bb4fd3563ed752b2913f2c9f658e56502404c202b2dad6a4803e" => :el_capitan
    sha256 "c4e2c1f4ec5f9bbf0148eb21e823645ffdc7c8f620f78fd8680fa8b09aacb7ed" => :yosemite
    sha256 "74f4f101c69bb956c7ebe2434370f6033a99be27fdca88b3ef5d484e7532bd00" => :mavericks
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-pgsql", "Enable the PostgreSQL backend"

  deprecated_option "pgsql" => "with-pgsql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on :postgresql if build.with? "pgsql"

  def install
    # https://github.com/Homebrew/homebrew/pull/33739
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-openssl=#{Formula["openssl"].opt_prefix}",
            "--with-sqlite3"]

    # Include the PostgreSQL backend if requested
    if build.with? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make", "install"
  end

  test do
    assert_match "PowerDNS Authoritative Server 3.4.9", shell_output("#{bin}/pdns_server --version")
  end
end
