class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.2.tar.gz"
  sha256 "8e46093af006e35354f6b3d58a70e3825cd0c074893be318f1858eddbe1cda86"

  bottle do
    cellar :any
    revision 1
    sha256 "c9ea507f3aa0033f6d149e63a1570ed1df721121fc1e70407780298377f76722" => :el_capitan
    sha256 "8e3a792371664b095af092b00615e2aad54c432968d6ad7bbbfdbaab9c980c82" => :yosemite
    sha256 "eab23b12aa22621a95aa3474833ec123e2ab41f1f5f3c47a04b8a61bc8f534e9" => :mavericks
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json", "/var/log/webdis.log", "#{var}/log/webdis.log"
    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  test do
    begin
      server = fork do
        exec "#{bin}/webdis", "#{etc}/webdis.json"
      end
      sleep 0.5
      # Test that the response is from webdis
      assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:7379/PING"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
