class Logentries < Formula
  include Language::Python::Virtualenv

  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.42.tar.gz"
  sha256 "52e4bfb61753a2fe9f83232e9cefe1aa9ebb87899572f070bad7293e1d891bf9"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "621576c922df103bdade11b81e00dc5b5cae674009f8a8a5d4e07018e2d7c7ae" => :high_sierra
    sha256 "aa732f1d7032ff522e40030d6ea86b76921f8e2f3e49e54db9bdfaad9890596a" => :sierra
    sha256 "771e2913718bb26593968fca3b91d854989b60fae3ebd823f9e7847f34f8800e" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "le", :because => "both install a le binary"

  def install
    virtualenv_install_with_resources
  end

  plist_options :manual => "le monitor"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/le</string>
        <string>monitor</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/le --help", 4)
  end
end
