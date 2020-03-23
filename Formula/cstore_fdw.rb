class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a592104d85c6707c70c85ffff3f0a2159af00874ddd6fd976f6237d07e6731e2" => :catalina
    sha256 "1bac3183125e671b83ffb7ad9370c8888d982a38793152d89552bf6c914e269e" => :mojave
    sha256 "53f05dae2e285ab58eff68ac4cb5fb047fd72e9444283f2fa94c73f50ea48840" => :high_sierra
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  def install
    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    return if ENV["CI"]

    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres",
           "-D", testpath/"test",
           "-c", "shared_preload_libraries=cstore_fdw",
           "-p", pg_port)
    end

    begin
      sleep 2

      cmds = ["CREATE EXTENSION cstore_fdw;",
              "CREATE SERVER cstore_server FOREIGN data WRAPPER cstore_fdw;",
              "CREATE FOREIGN TABLE T(x int) SERVER cstore_server OPTIONS(compression 'pglz');",
              "INSERT INTO T(x) SELECT 42;"]

      system "#{pg_bin}/createdb", "-p", pg_port, "test"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[0]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[1]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[2]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[3]

      assert_equal "42", shell_output("#{pg_bin}/psql -p #{pg_port} -d test -AXtc" \
                                      "'SELECT x from T;'").strip
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
