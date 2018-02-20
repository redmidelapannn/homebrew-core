class Upsub < Formula
  desc "High performance Pub/Sub messaging server for the Web"
  homepage "https://github.com/upsub/dispatcher"
  url "https://github.com/upsub/dispatcher/archive/v0.1.7-0.tar.gz"
  sha256 "bfa743baa10bd8fb02f9da1f48ea13fdb3481b3190ac749f9dd32b568f99b3e6"
  head "https://github.com/upsub/dispatcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab7d5450100e987e72c809a119e16774f4224789832cea62ec6d15e72d671949" => :high_sierra
    sha256 "d1a4b48bc8108333cdd0cdb77c6e54e52560fe9870ff65cd53fc83692b788791" => :sierra
    sha256 "e47cc0c254cf366d66869710319b88dcf7a1fa58841647b14b8219f749663a70" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/upsub"
    ln_s buildpath, "src/github.com/upsub/dispatcher"
    system "go", "build", "-o", bin/"upsub", "main.go"
  end

  plist_options :manual => "upsub"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/upsub</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec bin/"upsub"
    end
    sleep 3

    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
