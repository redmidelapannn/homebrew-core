class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.2.tar.gz&os=mac"
  version "2.2.2"
  sha256 "1ae672fc15638526980e132b92fe1896867fa765da79eadf5adf7cdcad946f88"

  bottle do
    cellar :any_skip_relocation
    sha256 "67d53b73a0a83ed8834a4b6cb4e3813fb4f4e688ab539a941b8b862d096774a1" => :el_capitan
    sha256 "966ac5da4a5741f5b57cb1232ac5c23213456f04e7402a92f66d005b1e2d2e04" => :yosemite
    sha256 "0f19bd02900d1cc16ba6b0db30df6cc806afc19ab3e619a6990c2899988cab44" => :mavericks
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

    mkpath "#{libexec}/log"
    touch "#{libexec}/log/orientdb.err"
    touch "#{libexec}/log/orientdb.log"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end
end
