class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.4.2.tar.gz"
  sha256 "f6d0df00279944f91ac672bdb6507a6c63755ba7cdd7e16022c4cb8ddaaf0034"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c9b6645c160ceeb6c1f822c97121df89dc3da701db758af6f04aad675aef9413" => :sierra
    sha256 "15bc69a812e5cc0c658322b77df362630914df37695eabd0bae54755fff34f8a" => :el_capitan
    sha256 "d19c9d840b9350fe5831ffd3adec216fe45a0b3b1357e6e0998c9d9d78e61406" => :yosemite
  end

  devel do
    url "https://github.com/pgRouting/pgrouting/archive/v2.5.0-rc.tar.gz"
    sha256 "c0b091382b8df8ca7d3f7a4b168cfc13386276b6b7e47a2c6f85fc907081c3c0"
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
