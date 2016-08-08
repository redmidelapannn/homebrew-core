class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-5.6.tar.gz"
  sha256 "9ea24d8cacdf2e19ba60487f3e9dfefa83c18cb3987571abc44b858ce0db7c3e"
  head "https://github.com/VoltDB/voltdb.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "11dfd114ac5da10df747fca65b366b192f9e7c861b7ee557d6a2f6d4df2a9830" => :el_capitan
    sha256 "b4f1380d8da33757822427255fdb13aea440ad2dd45635290ad9b8239c181386" => :yosemite
    sha256 "d4076ea803e4cd2fe07ef605b888b6b496cbeb66ad13ec7ee36b1e51150d1ad1" => :mavericks
  end

  depends_on :ant => :build

  def install
    system "ant"

    inreplace Dir["bin/*"] - ["bin/voltadmin", "bin/voltdb", "bin/rabbitmqloader"],
      %r{VOLTDB_LIB=\$VOLTDB_HOME\/lib}, "VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb"

    (lib/"voltdb").install Dir["lib/*"]
    lib.install_symlink lib/"voltdb/python"
    prefix.install "bin", "tools", "voltdb", "version.txt", "doc"
  end

  test do
    assert_match version.to_s, shell_output("voltdb --version")
  end
end
