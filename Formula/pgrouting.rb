class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.4.2.tar.gz"
  sha256 "f6d0df00279944f91ac672bdb6507a6c63755ba7cdd7e16022c4cb8ddaaf0034"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e9bbbffadeb7355e3cff4982950d66d56193145f0d00c3adc41d957b11697504" => :sierra
    sha256 "c0441cb3e0ed4da157a9d8bfd4cea7689d7f4e76deb8d041d0e3328d742fdb63" => :el_capitan
    sha256 "06216a6ee87b2819ea9563378e6ab394592a5845e3ee68281aefcde090024796" => :yosemite
  end

  devel do
    url "https://github.com/pgRouting/pgrouting/archive/v2.5.0-alpha.tar.gz"
    sha256 "cb8e5af9bf90d805eee57276c2e69a7538a7c704063c3748dcbc72915c4fd3fd"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port
      system "#{pg_bin}/psql", "-p", pg_port, "--command", "CREATE DATABASE test;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION postgis;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgrouting;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
