require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.2.0.tar.gz"
  sha256 "1cedceb22f051d4d80a75e4ac7a875164e3ee15bd6f6edc68dfca7c9265a2481"
  revision 1
  head "https://github.com/begriffs/postgrest.git"

  bottle do
    sha256 "f4aed0bb1324613cecadbacca3f0654f280ace5d9b0b3a8af8ab306aacab0c72" => :sierra
    sha256 "801f4c08371f06f3e767b6c4527723989f2a65af0d0bd0f3f19760d5c1c9b405" => :el_capitan
    sha256 "1d14b831d5fb028e163b2516101913c61ccd2e934902bfeda0939eeb1c642aa3" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    pg_bin  = Formula["postgresql"].bin
    pg_port = 55561
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      pid = fork do
        exec "postgrest", "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}",
          "-a", pg_user, "-p", "55560"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
    ensure
      begin
        Process.kill("TERM", pid) if pid
      ensure
        system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
          "-s", "-m", "fast"
      end
    end
  end
end
