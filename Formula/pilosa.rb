class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.3.1.tar.gz"
  sha256 "5ff34f07a503a8d1b22911409dfd426d16a451b76a3deff503363db17204b9cb"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    require "time"
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/pilosa/"
    ln_s buildpath, buildpath/"src/github.com/pilosa/pilosa"
    system "glide", "install"
    ts = Time.now.utc.strftime("%FT%T%z")
    system "go", "build", "-o", bin/"pilosa", "-ldflags",
           "-X github.com/pilosa/pilosa/cmd.Version=#{version} -X github.com/pilosa/pilosa/cmd.BuildTime=#{ts}",
           "github.com/pilosa/pilosa/cmd/pilosa"
  end

  plist_options :manual => "pilosa server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/pilosa</string>
            <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa", "server", "--bind", "10101"
      end
      sleep 0.5
      assert_match(/^Welcome. Pilosa is running.*/, shell_output("curl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
