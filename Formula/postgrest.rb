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
    sha256 "ae7bb0d4c59fe631da87f50963152cc901b17bb21c33c1d664a131f199cfb7a7" => :catalina
    sha256 "4fd880d656c648b722f47b0a897620c084198cd9ea22a1d61272b8f9d4b89ec1" => :mojave
    sha256 "032d19d919584380062042e701c2f997a9664f745da351d26158db30054bb74d" => :high_sierra
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
