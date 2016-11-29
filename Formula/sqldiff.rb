class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2016/sqlite-src-3150200.zip"
  version "3.15.2"
  sha256 "38a1e867b5b1a58ba3731a63ffe69a2271d79bd0723d21c5a9a71e4cb7452a83"

  bottle do
    cellar :any_skip_relocation
    sha256 "b63ed50d40e2f9c5325c8e671329297dc70fe8ffb0b9e76464304c2d17884247" => :sierra
    sha256 "aa598baf70f04af81abf4827239f640c797c4bace58f076ba2025c779103415b" => :el_capitan
    sha256 "2bd455f968ee9b5087ac73b168678cde1c93618e8753f27e4faac2b87f3dc663" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
