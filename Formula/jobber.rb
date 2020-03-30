class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.1.tar.gz"
  sha256 "891b1f86f65690b36cfd7f0c3c78f9d81fdc976e85a8055ac4da0daf59adf066"
  head "https://github.com/dshearer/jobber.git"

  depends_on "go" => :build

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "libexecdir=#{libexec}", "sysconfdir=#{etc}"
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{libexec}/jobbermaster</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_equal "1.4.1", shell_output("#{bin}/jobber -v").chomp
  end
end
