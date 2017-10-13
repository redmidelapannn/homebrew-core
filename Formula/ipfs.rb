class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.11",
      :revision => "41102bdc4d14f106b14cffe2640dd8981f8b31ef"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8f8baf04643ee337232e27f9c62ea096e67e61ba24323cf6c240239bf74abd51" => :high_sierra
    sha256 "d17a6bcb5561d4668af37d7fe1b5a9c6f5051ae7a31ec285ac77d8d4ee2786bc" => :sierra
    sha256 "89c4006a55f7fc978ccd5f3fc78a77e47b8a9fd53114546a867d306535b47f35" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gx"
  depends_on "gx-go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"
  end

  plist_options :manual => "ipfs daemon"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ipfs</string>
        <string>daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"ipfs", "version"
  end
end
