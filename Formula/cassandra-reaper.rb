class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.3.0/cassandra-reaper-1.3.0-release.tar.gz"
  sha256 "79c190c51c3404c2efc7f7f1aafa7cfd91f2280cbb1fe719e668966836904efd"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccdb395db7fd60e17a51d75dd33afce272e0309f97970054c0bf6980028e01e7" => :mojave
    sha256 "cc158a75d03d8096f3a13ea76528722aa31b7999189918d2955e9e31e18855ae" => :high_sierra
    sha256 "cc158a75d03d8096f3a13ea76528722aa31b7999189918d2955e9e31e18855ae" => :sierra
  end

  depends_on :java => "1.8"

  def install
    prefix.install "bin"
    share.install "server/target" => "cassandra-reaper"
    etc.install "resource" => "cassandra-reaper"
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/cassandra-reaper"
      end
      sleep 10
      output = shell_output("curl -Im3 -o- http://localhost:8080/webui/")
      assert_match /200 OK.*/m, output
    ensure
      Process.kill("KILL", pid)
    end
  end
end
