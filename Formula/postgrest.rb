require "language/haskell"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v6.0.2.tar.gz"
  sha256 "8355719e6c6bdf03a93204c5bcf2246521e0ffc02694b2cebfc576d4eae9a0c9"
  head "https://github.com/PostgREST/postgrest.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "837b5a01991756cf36f40ac336802113d1bd699360d7d86449f7199578b54761" => :catalina
    sha256 "2ea74796a0f8df6367c8b628d829b98bd5dd7aa79fc7deb0a391c93a0da40632" => :mojave
    sha256 "c42f1e9390e2b817b38d7a921999838b5de7241c6fd4cb02b5ef03310cdb4782" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "postgresql"

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    return if ENV["CI"]

    pg_bin  = Formula["postgresql"].bin
    pg_port = free_port
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %Q("-p #{pg_port}"), "start"

    begin
      port = free_port
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      (testpath/"postgrest.config").write <<~EOS
        db-uri = "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}"
        db-schema = "public"
        db-anon-role = "#{pg_user}"
        server-port = #{port}
      EOS
      pid = fork do
        exec "#{bin}/postgrest", "postgrest.config"
      end
      sleep 5 # Wait for the server to start

      output = shell_output("curl -s http://localhost:#{port}")
      assert_match "200", output
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
