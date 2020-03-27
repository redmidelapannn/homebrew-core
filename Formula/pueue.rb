class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.2.1.tar.gz"
  sha256 "a8411d6e5648c4b42ccc458bb1908bef47515a4f015abcf34af0e2b5181a7850"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9114b439d6e55eea60028f677f114cf385efd4d6e47566ef9e65408931e951a" => :catalina
    sha256 "7e86f09ab4550cb419b4865a7ccbdb89283cc90f632d385c26c029c2b2e9cf27" => :mojave
    sha256 "f45cde5b31d2509c3b277add9daf1b048676bbb3453fffeec1b2066c7b51e59b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"

    prefix.install_metafiles
  end

  plist_options :manual => "pueued"

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
            <string>#{opt_bin}/pueued</string>
            <string>--verbose</string>
          </array>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/pueued.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/pueued.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir testpath/"Library/Preferences"

    begin
      pid = fork do
        exec bin/"pueued"
      end
      sleep 5
      cmd = "#{bin}/pueue status"
      assert_match /Task list is empty.*/m, shell_output(cmd)
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Pueue daemon #{version}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version}", shell_output("#{bin}/pueue --version")
  end
end
