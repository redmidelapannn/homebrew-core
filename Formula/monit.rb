class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.26.0.tar.gz"
  sha256 "87fc4568a3af9a2be89040efb169e3a2e47b262f99e78d5ddde99dd89f02f3c2"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "c6b99a9ae40db8dfbba621f1cd1c9ff71ce83ce57edf1bcec45fee56df100aa9" => :catalina
    sha256 "3d8a6809f69d7c8d5394e227bdb9dccbd771c336dc308d8ff7af610980530ac2" => :mojave
    sha256 "f2e25ab68025ce55bd186d3dd29f151a2485294561610e54a4fc3b26a66b9a9d" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  plist_options :manual => "monit -c #{HOMEBREW_PREFIX}/etc/monitrc"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>              <string>#{plist_name}</string>
          <key>ProcessType</key>        <string>Adaptive</string>
          <key>Disabled</key>           <false/>
          <key>RunAtLoad</key>          <true/>
          <key>LaunchOnlyOnce</key>     <false/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/monit</string>
            <string>-I</string>
            <string>-c</string>
            <string>#{etc}/monitrc</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
