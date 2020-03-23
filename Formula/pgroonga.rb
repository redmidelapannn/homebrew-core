class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.5.tar.gz"
  sha256 "ff9962e4f5e54deb9876720739cb10bf0e14e4558e9ee636b96ea6de664a9253"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1d70a71be39949adb0894b18055ee211b0a45e05848297ffa07d024ba2e5ec73" => :catalina
    sha256 "07674eaf0442b6a480496b53aaed95f61ac22037c9551a957d2c59c8981418ea" => :mojave
    sha256 "8bc6aeb6fa9fca0e5a9cc00ea42ab58dc801fd919a35215263fdf80580098911" => :high_sierra
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
    return if ENV["CI"]

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
