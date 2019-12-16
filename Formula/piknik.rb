class Piknik < Formula
  desc "Copy/paste anything over the network"
  homepage "https://github.com/jedisct1/piknik"
  url "https://github.com/jedisct1/piknik/archive/0.9.1.tar.gz"
  sha256 "a682e16d937a5487eda5b0d0889ae114e228bd3c9beddd743cad40f1bad94448"
  head "https://github.com/jedisct1/piknik.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "085dfd50bfb254b8f1c2feab294665591299c9334878aea44a2fddc3f5572739" => :catalina
    sha256 "4b014f483d8555c98fd17664e59fa8e00e67fabdf860cd332f870eb86df7fa41" => :mojave
    sha256 "98fd12dd1dea894bdddac59086bcad80c6a4556cc81995f8c767e46841f95a19" => :high_sierra
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
    lines = genkeys.lines.grep(/\s+=\s+/).map { |x| x.gsub(/\s+/, " ").gsub(/#.*/, "").gsub("0.0.0.0", "127.0.0.1") }.uniq
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
