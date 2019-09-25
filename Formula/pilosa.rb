class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.4.0.tar.gz"
  sha256 "9b6524049e4e927179a5a1122129e68c66712752a12ebd3dedf9010188ae73a5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f155d14fbfd5ccf46bf63a4bc395cc5c840feee1eb0942e07209020963746cd8" => :mojave
    sha256 "01752e1eee984106410b41b84297a87d5cb9f44b4f4eb5d04624a914d7804773" => :high_sierra
    sha256 "17cdf60552afaf352a9d31b33523db0eb3c1875bea7ac8484437671705f48dc3" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    cd "src/github.com/pilosa/pilosa" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "pilosa server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/pilosa</string>
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
        exec "#{bin}/pilosa", "server"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
