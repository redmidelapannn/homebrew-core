class Piknik < Formula
  desc "Copy/paste anything over the network"
  homepage "https://github.com/jedisct1/piknik"
  url "https://github.com/jedisct1/piknik/archive/0.9.1.tar.gz"
  sha256 "a682e16d937a5487eda5b0d0889ae114e228bd3c9beddd743cad40f1bad94448"
  head "https://github.com/jedisct1/piknik.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3e8159b1b6b79b776b6d03ff093855d50a1f054355daf614fd366cb7431175e3" => :catalina
    sha256 "61c1da818eb83dcdb251e6bf5358b0ba199967520cd16725692e0bacee7c7fc5" => :mojave
    sha256 "a2fbc4d54aff33d62a6da641d4531de0d4a15de2465fef74c0104449fa2f86bf" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/jedisct1/"
    dir.install Dir["*"]
    ln_s buildpath/"src", dir
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"piknik", "."
      (prefix/"etc/profile.d").install "zsh.aliases" => "piknik.sh"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    In order to get convenient shell aliases, put something like this in #{shell_profile}:
      . #{etc}/profile.d/piknik.sh
  EOS
  end

  plist_options :manual => "piknik -server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/piknik</string>
          <string>-server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    conffile = testpath/"testconfig.toml"

    genkeys = shell_output("#{bin}/piknik -genkeys")
    lines = genkeys.lines.grep(/\s+=\s+/).map { |x| x.gsub(/\s+/, " ").gsub(/#.*/, "") }.uniq
    conffile.write lines.join("\n")
    pid = fork do
      exec "#{bin}/piknik", "-server", "-config", conffile
    end
    begin
      sleep 1
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-copy"], "w+") do |p|
        p.write "test"
      end
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-move"], "r") do |p|
        clipboard = p.read
        assert_equal clipboard, "test"
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      conffile.unlink
    end
  end
end
