class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/v1.2.0.tar.gz"
  sha256 "98e24d748550f01dd8775e5e40f3ae657f5b513f875a15081cdcdc567b745480"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e205b40bfc180cdd34885f4414554ce9f1ec6b154feab871e16adea97046b9ba" => :mojave
    sha256 "d479896635db1fb243815c6e4e7cc027c380cfce9491e5ceae17388b9c7a5df6" => :high_sierra
    sha256 "c684878cef8ccdbaf4aefeea9250dfb922cf6487e5dcd204e45c4a416d570d22" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/nsqio/nsq").install buildpath.children
    cd "src/github.com/nsqio/nsq" do
      system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
      prefix.install_metafiles
    end
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  plist_options :manual => "nsqd -data-path=#{HOMEBREW_PREFIX}/var/nsq"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/nsqd</string>
        <string>-data-path=#{var}/nsq</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/nsq</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/nsqd.error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/nsqd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    begin
      lookupd = fork do
        exec bin/"nsqlookupd"
      end
      sleep 2
      d = fork do
        exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
      end
      sleep 2
      admin = fork do
        exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
      end
      sleep 2
      to_file = fork do
        exec bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                                "--output-dir=#{testpath}",
                                "--topic=test"
      end
      sleep 2
      system "curl", "-d", "hello", "http://127.0.0.1:4151/pub?topic=test"
      sleep 2
      dat = File.read(Dir["*.dat"].first)
      assert_match "test", dat
      assert_match version.to_s, dat
    ensure
      Process.kill(15, lookupd)
      Process.kill(15, d)
      Process.kill(15, admin)
      Process.kill(15, to_file)
      Process.wait lookupd
      Process.wait d
      Process.wait admin
      Process.wait to_file
    end
  end
end
