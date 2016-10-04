class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v0.7.0",
      :revision => "a189091a3530051285c12c726ca28ea55e015336"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "775f16ba25c542c0c83da47a3db2cad23a9676478bfd35de2f4ba7ce6fc5c2bd" => :sierra
    sha256 "945e25aa93e84e243cbef5f5435a3c8131721990356cf51fb94fa7159855c33f" => :el_capitan
    sha256 "559dd370ce4a2ead2e01ec24fe2543579177e437025ed9da5f365a6623b59647" => :yosemite
  end

  option "with-web-ui", "Installs the consul web ui"

  depends_on "go" => :build

  resource "web-ui" do
    url "https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_web_ui.zip"
    sha256 "42212089c228a73a0881a5835079c8df58a4f31b5060a3b4ffd4c2497abe3aa8"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/consul").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
      zsh_completion.install "contrib/zsh-completion/_consul"
    end

    # install web-ui to package share folder.
    (pkgshare/"web-ui").install resource("web-ui") if build.with? "web-ui"
  end

  def caveats; <<-EOS.undent
    If consul was built with --with-web-ui, you can activate the UI by running
    consul with `-ui-dir #{pkgshare}/web-ui`.
    EOS
  end

  plist_options :manual => "consul agent -dev -advertise 127.0.0.1"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/consul</string>
          <string>agent</string>
          <string>-dev</string>
          <string>-advertise</string>
          <string>127.0.0.1</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/consul.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/consul.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
