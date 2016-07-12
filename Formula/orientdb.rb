class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  # url "http://central.maven.org/maven2/com/orientechnologies/orientdb-community/2.2.4/orientdb-community-2.2.4.tar.gz"
  url "https://search.maven.org/remotecontent?filepath=com/orientechnologies/orientdb-community/2.2.4/orientdb-community-2.2.4.tar.gz"
  sha256 "9505522872cd653c8ae9d98ac0b0786b543e9a6936750dc3b07f91082f7085e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7032a0d4dcdc5c51efdd29e4981103aadf10121a4e3df3fc603b82d9be5b0dd" => :el_capitan
    sha256 "a1059f5e6e23922d0bb185368be038244630c4de6a715504caa353747e24da65" => :yosemite
    sha256 "b07f2cdc638532a2a6e2a0bbabdb267d561059b6429481fe27bda3b6582dd45c" => :mavericks
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

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<-EOS.undent
         <entry name="server.database.path" value="#{var}/db/orientdb" />
         </properties>
       EOS
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/server.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/shutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def post_install
    (var/"db/orientdb").mkpath
    (var/"run/orientdb").mkpath
    (var/"log/orientdb").mkpath
    touch "#{var}/log/orientdb/orientdb.err"
    touch "#{var}/log/orientdb/orientdb.log"
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>", "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    system "#{bin}/orientdb", "start"
    sleep 4

    begin
      assert_match "OrientDB Server v.2.2.4", shell_output("curl -I localhost:2480")
    ensure
      system "#{bin}/orientdb", "stop"
    end
  end
end
