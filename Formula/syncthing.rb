class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
    :tag => "v0.14.1", :revision => "25a7b0a6f8320ea222e50a81a7eff3cdf27d65ae"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6cbd7385e1bd2477e7bd55b480916ddd79e3b7cbf4825a08cb94d8d35d1a116" => :el_capitan
    sha256 "20908fc6ec0b644988520c7eb14ca543621d545fe9aaea7f125b50a6d40d776e" => :yosemite
    sha256 "cc8ac1187d613c7fa79774a88ff6a8503f91ed4cfdfaf98d910b22380be24a59" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/".syncthing-gopath"
    mkdir_p buildpath/".syncthing-gopath/src/github.com/syncthing"
    cp_r cached_download, buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    cd buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    system "./build.sh", "noupgrade"
    bin.install "syncthing"
  end

  plist_options :manual => "syncthing"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing</string>
          <string>-no-browser</string>
          <string>-no-restart</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <true/>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
