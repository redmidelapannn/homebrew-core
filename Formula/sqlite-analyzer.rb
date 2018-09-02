class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3240000.zip"
  version "3.24.0"
  sha256 "72a302f5ac624079a0aaf98316dddda00063a52053f5ab7651cfc4119e1693a5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dd516cf694106ee06aa080953dc86ad5560562ecba3695803d674c44eaaac29d" => :mojave
    sha256 "b0693cbbad23ec44cec06ac96c49ee61b7818aacaa70a8190ccabf9d3086caff" => :high_sierra
    sha256 "ada7cf84067b0de1c2ff806282ec7325b630b3a6013d202831241f8739986879" => :sierra
    sha256 "b39262e67f9113d02626493d3b79f71171cd122f4ea6fba01e65231cc65b82a2" => :el_capitan
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
