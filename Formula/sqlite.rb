class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2019/sqlite-autoconf-3300100.tar.gz"
  version "3.30.1"
  sha256 "8c5a50db089bd2a1b08dbc5b00d2027602ca7ff238ba7658fabca454d4298e60"

  bottle do
    cellar :any
    sha256 "62ee665d13365b0553f4525749655ecd1d98cb67f9e395891ebdba173e7e1ff7" => :catalina
    sha256 "20b0c518c33fed0e9fbd1690f365cf012e283abccd491ebc11956b122170d61f" => :mojave
    sha256 "728b4f5d9eee2bbb63bc48878e970d45a766ebf7d37cf6a341f3f9f90c266eb6" => :high_sierra
  end

  keg_only :provided_by_macos, "macOS provides an older sqlite3"

  depends_on "readline"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
