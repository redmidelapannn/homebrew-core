class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.7.24/traefik-v1.7.24.src.tar.gz"
  version "1.7.24"
  sha256 "8f9e0ba3cbb6537e47c675c806d6e6de3267241a48ea7291b19673d524f78a88"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1a7c32dfdf6eaedfa50d5df957d172b767cd2b1dc03cbc722abe2968bc72484c" => :catalina
    sha256 "9dad3681617e363e4180337058cf1cf439b46e9437e7e4c47ae3aa7816004292" => :mojave
    sha256 "ee9b35f98288e2601aa09f16d38d5e2a9c2e66edfa1b038677254eed5f7dc65c" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    cd "src/github.com/containous/traefik" do
      cd "webui" do
        system "yarn", "upgrade"
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "traefik"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/traefik</string>
            <string>--configfile=#{etc/"traefik/traefik.toml"}</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/traefik.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/traefik.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    web_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [web]
        address = ":#{web_port}"
      [entryPoints.http]
        address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match /404 Not Found/m, shell_output(cmd)
      sleep 1
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
