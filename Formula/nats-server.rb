class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.6.tar.gz"
  sha256 "029d70ffe5e0f38e7741c6e7417ef0ecc88dd178ae5b117f1afa342b43425578"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "014a65df749d8c467db686367e2953ca0cd6a00a84d0f2591b2eb91a3b32378b" => :catalina
    sha256 "9cd0d1ba300fcfbdf629d27329cf4a986b7acdc675586125d493060882f9cee1" => :mojave
    sha256 "307b3cf1ffefa5fd1ccaa73f36503f5f1babb88d4524694366c417a2f9d93685" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-server"
    prefix.install_metafiles
  end

  plist_options :manual => "nats-server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/nats-server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec bin/"nats-server",
           "--port=8085",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match version.to_s, shell_output("curl localhost:8085")
      assert_predicate testpath/"log", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
