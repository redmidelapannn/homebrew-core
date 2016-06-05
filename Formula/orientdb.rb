class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.2.0.tar.gz&os=mac"
  version "2.2.0"
  sha256 "32db9f634433563b15654a3f726750f35b53af77f0b9bd4fb15ca57434c252e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c8761fa5fcc3898f175bce99851439acacb50ccb82665ad50c0e4b3944727e3" => :el_capitan
    sha256 "a64434139e4dd7a1c9031632ca8061dd435b1136b1d04f47171a0352d73803aa" => :yosemite
    sha256 "a7b9e55ada41a386e94c416544ba6f89e104ab10fde1cb5283aae16ce1757e2d" => :mavericks
  end

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/maggiolo00/84835e0b82a94fe9970a/raw/1ed577806db4411fd8b24cd90e516580218b2d53/orientdbsh"
    sha256 "d8b89ecda7cb78c940b3c3a702eee7b5e0f099338bb569b527c63efa55e6487e"
  end

  def install
    rm_rf Dir["{bin,benchmarks}/*.{bat,exe}"]

    inreplace %W[bin/orientdb.sh bin/console.sh bin/gremlin.sh],
      '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    mkpath "#{var}/log/orientdb"
    touch "#{var}/log/orientdb/orientdb.err"
    touch "#{var}/log/orientdb/orientdb.log"
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end

  test do
    pid = fork do
      system "#{bin}/orientdb", "start"
    end
    sleep 2
    begin
      assert_match "OrientDB Server v.2.2.0", shell_output("curl -I localhost:2480")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
