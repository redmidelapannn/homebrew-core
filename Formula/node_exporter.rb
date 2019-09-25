class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.18.1.tar.gz"
  sha256 "9ddf187c462f2681ab4516410ada0e6f0f03097db6986686795559ea71a07694"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c4afe37dca33b9210fc9db16590b26f5c33b56558c9be0aa932e0bf0f4820122" => :mojave
    sha256 "c1b6f2b7aaabc337eb4593067eea716886f9bb194fc4cc3320362db40f4a4c3f" => :high_sierra
    sha256 "98aa5e62c9c7ebe2653826781e47347b1b16a6095ec62ba6c2d0565388fe2de1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/prometheus/node_exporter").install buildpath.children
    cd "src/github.com/prometheus/node_exporter" do
      system "go", "build", "-o", bin/"node_exporter", "-ldflags",
           "-X github.com/prometheus/node_exporter/vendor/github.com/prometheus/common/version.Version=#{version}",
           "github.com/prometheus/node_exporter"
      prefix.install_metafiles
    end
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
