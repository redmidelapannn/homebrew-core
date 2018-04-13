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
    sha256 "a71c941e820127ee2a22bf7d5bb80504f7380fc46d942cfabf0cbd1523339b39" => :high_sierra
    sha256 "34fc4abf67e53a88022b98c1edca0d5353addf2eea73162cc3094ae68b945a9c" => :sierra
    sha256 "a2ae060984c9553ecc7c226d68f8d42f623a828f0dd8a64d1a4bc80bc5b4ea47" => :el_capitan
  end

  conflicts_with "le", :because => "both install a le binary"

  depends_on "python@2"

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
