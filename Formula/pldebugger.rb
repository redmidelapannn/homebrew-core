class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "https://git.postgresql.org/gitweb/"
  url "https://git.postgresql.org/git/pldebugger.git",
      :tag => "REL-9_5_0",
      :revision => "85d7b3b2821301e182d5974d9e6f353d7a241eff"
  version "1.0" # See default_version field in pldbgapi.control
  revision 2
  head "https://git.postgresql.org/git/pldebugger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0d1954334b2c84175c8cc1fc0c3e10554c13a6d1de3c32a3eb333c08e3e2308" => :sierra
    sha256 "f981f7f8e634338e48304153fc2f95d3eb02602aadf43be8c595e9e03269ac69" => :el_capitan
    sha256 "76cf973d816db1e0989a655a6abfa835b292a760a19152417f45c1c1fa39aafc" => :yosemite
  end

  depends_on "postgresql"

  def install
    ENV["USE_PGXS"] = "1"
    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    system "make", "PG_CONFIG=#{pg_config}"
    mkdir "stage"
    system "make", "DESTDIR=#{buildpath}/stage", "PG_CONFIG=#{pg_config}", "install"
    lib.install Dir["stage/**/lib/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pldbgapi;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
