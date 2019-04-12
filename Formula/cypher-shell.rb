class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://github.com/neo4j/cypher-shell"
  url "https://github.com/neo4j/cypher-shell/releases/download/1.1.9/cypher-shell.zip"
  version "1.1.9"
  sha256 "027dd83ff10ac24077dc9ab7e1be4a624f8cadeab4039bb6800584d94fecf49f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f7f49876322fe23df3fcda839ba3efdbd3e3d58f7ecdc3466e687d84a81dc84" => :mojave
    sha256 "5f7f49876322fe23df3fcda839ba3efdbd3e3d58f7ecdc3466e687d84a81dc84" => :high_sierra
    sha256 "02cd34433d5c7dd6c3e70f00c61fc2d5dbcccae4f71df683dfdca0e8c19e46a6" => :sierra
  end

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]

    # Needs the jar, but cannot go in bin
    share.install ["cypher-shell.jar"]

    # Copy the bin
    bin.install ["cypher-shell"]
    bin.env_script_all_files(share, :NEO4J_HOME => ENV["NEO4J_HOME"])
  end

  test do
    # The connection will fail and print the name of the host
    assert_match /doesntexist/, shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
