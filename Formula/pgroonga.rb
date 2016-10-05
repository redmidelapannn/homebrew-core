class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.3.tar.gz"
  sha256 "b160973b5573f3acc3be2d0b29a91441498af39201ffdaf06b9824e6705d920c"
  revision 1

  bottle do
    cellar :any
    sha256 "62f73def4de85e55d578f271dc64dc6a6a93244415eccf1de47f4973f7279886" => :sierra
    sha256 "fca80c6418079c50d49a63662d11cd43c13c84db2998d4e6ba20dd5e7f931b31" => :el_capitan
    sha256 "1daf2a1629f8c539b0d2e07c176adb174b623c404277b10c48ad735f66d630f4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgroonga;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
