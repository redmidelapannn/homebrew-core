class SqliteRegexp < Formula
  desc "SQLite extension providing the REGEXP operator"
  homepage "https://www.sqlite.org/src/file/ext/misc/regexp.c"
  url "https://www.sqlite.org/2019/sqlite-src-3270200.zip"
  version "3.27.2"
  sha256 "15bd4286f2310f5fae085a1e03d9e6a5a0bb7373dcf8d4020868792e840fdf0a"

  bottle do
    sha256 "f981928dd2fb3b23cdb8c6960867f5be9d2279aba636270c12ce623f1d1692a7" => :mojave
    sha256 "8708ade7e4bb1ea000dea75c83864b526d61196fe07f7c2b093fd0c2cbfbbad1" => :high_sierra
    sha256 "b2131c1f23cfca45d67ebd9d490b774e89b8c212b7b93fd04585ad32098ad7ac" => :sierra
  end

  depends_on "sqlite"

  def install
    system "/usr/bin/install", "-d", "#{lib}/#{name}"
    system ENV.cc, "-g", "-fPIC", "-dynamiclib", "ext/misc/regexp.c",
      "-o", "#{lib}/#{name}/regexp.dylib"
  end

  def caveats; <<~EOS
    sqlite-regexp does not work with the macOS-provided sqlite3. To invoke the
    Homebrew-supplied keg-only sqlite3, run:

      #{Formula["sqlite"].opt_bin}/sqlite3

    SQLite does not automatically load extensions. To load the regexp extension,
    run this command at the sqlite prompt:

      .load #{HOMEBREW_PREFIX}/lib/#{name}/regexp

    You can also add it to your ~/.sqliterc file to have it run automatically.

    This implementation of the REGEXP operator supports a subset of PCRE syntax
    documented in the regexp.c source file, which can be easily viewed here:

      #{homepage}
  EOS
  end

  test do
    system "#{Formula["sqlite"].opt_bin}/sqlite3",
      "-cmd", ".load #{HOMEBREW_PREFIX}/lib/#{name}/regexp",
      ":memory:", "SELECT 'abba' REGEXP 'ab*a';"
  end
end
