class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://www.sqlite.org/2019/sqlite-src-3270100.zip"
  version "3.27.1"
  sha256 "f0fcc4da31e61a9c516f7c1ff21ec71ad6a05b1fe88f7f0b4d9aa54649c85986"
  revision 1

  bottle do
    cellar :any
    sha256 "8e70ee1adc0b54a3aabba44a4c12a0eb066081b617e9228c4b2bb858b0b5c473" => :mojave
    sha256 "899e9d0cc6734e8005b57f412991cbdd94b17d65a61177a987b8b529355ffc16" => :high_sierra
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
    ]

    system "./configure", *args
    system "make", "install"

    system ENV.cc, "-g", "-fPIC", "-dynamiclib", "ext/misc/regexp.c",
      "-o", "regexp.dylib"
    system "/usr/bin/install", "-d", "#{lib}/sqlite3"
    system "/usr/bin/install", "regexp.dylib", "#{lib}/sqlite3"
  end

  def caveats; <<~EOS
    This sqlite has been built with the regexp extension, which enables use of
    SQLite's non-standard REGEXP operator. This implementation of the REGEXP
    operator supports a subset of PCRE syntax documented in the regexp.c source
    file, which can be easily viewed here:
      https://www.sqlite.org/src/artifact/79345bf03496155a

    The extension is not loaded automatically. To load it interactively within the
    sqlite3 program, use:
      .load #{lib}/sqlite3/regexp

    You can put the above command in your ~/.sqliterc file to have the extension
    loaded every time you start sqlite3.

    Note that the sqlite3 program supplied with macOS does not support loading
    extensions. You must be using the sqlite3 program located here:
      #{bin}/sqlite3
  EOS
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

    system "#{bin}/sqlite3", "-cmd", ".load #{lib}/sqlite3/regexp",
      "dummy.db", "SELECT 'abba' REGEXP 'ab*a';"
  end
end
