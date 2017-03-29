class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-1.1.9.tar.gz"
  sha256 "4f19b2ac3fef7299a9324ec84d521a5c4a9f01df190f1eff59ae5b44297f4e1d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "de4cb53df5c48a97c97c91805d3c80b48e8b2bc0f616ef83304e2e9c9743fcca" => :sierra
    sha256 "29fbc1f493c5aef3fade734ae0ea82af85705ecdf5eb1b277624ddb88986d753" => :el_capitan
    sha256 "d3c4f4efc09810a5cd62daa92e4ba2b7aa101bacebc28bee2eead208be261b38" => :yosemite
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
