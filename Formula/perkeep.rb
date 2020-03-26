class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  url "https://github.com/perkeep/perkeep.git",
      :tag      => "0.10",
      :revision => "0cbe4d5e05a40a17efe7441d75ce0ffdf9d6b9f5"
  head "https://github.com/perkeep/perkeep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4db4a8a51b5a7fdca08b1392212794fe59dcb778a8e5c02f6c40342a0469889c" => :catalina
    sha256 "bac805f2fe6906eab5450465d4b1baf966f6e6a914d94161871eaec9afbd6604" => :high_sierra
  end

  depends_on "go@1.10" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/perkeep.org").install buildpath.children - [buildpath/".brew_home"]
    cd "src/perkeep.org" do
      system "go", "run", "make.go"
      prefix.install_metafiles
    end
    bin.install Dir["bin/*"].select { |f| File.executable? f }
  end

  plist_options :manual => "perkeepd"

  def plist
    <<~EOS
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
          <string>#{opt_bin}/perkeepd</string>
          <string>-openbrowser=false</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"pk-get", "-version"
  end
end
