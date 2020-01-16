class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter.git",
    :tag      => "v0.18.1",
    :revision => "3db77732e925c08f675d7404a8c46466b2ece83e"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "76a5d0ea5f0a9073616fb128ba49d8f68d21c35d7a18d5c9e9abf744b2f0c83d" => :catalina
    sha256 "4c0333f53d7b8e3f0f2c878e7603e8d76c3c274710897138fa6debb00898eb36" => :mojave
    sha256 "1e3848b5701412583acbd485f93440e6efb397eae558919746b632e863fdca34" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "node_exporter"
    prefix.install_metafiles
  end

  def caveats; <<~EOS
    When used with `brew services`, node_exporter's configuration is stored as command line flags in
      #{etc}/node_exporter.args

    Example configuration:
      echo --web.listen-address :9101 > #{etc}/node_exporter.args

    For the full list of options, execute
      node_exporter -h
  EOS
  end

  plist_options :manual => "node_exporter"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>sh</string>
          <string>-c</string>
          <string>#{opt_bin}/node_exporter $(&lt; #{etc}/node_exporter.args)</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/node_exporter.err.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/node_exporter.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match /node_exporter/, shell_output("#{bin}/node_exporter --version 2>&1")
    begin
      pid = fork { exec bin/"node_exporter" }
      sleep 2
      assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
