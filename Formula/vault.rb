# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.3.2",
      :revision => "d433f38172a75f69ab0f40158936f9ac7c24f0ee"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c1f23924efe2456285698c9c946df5b6505359302ad9201277ad1c0c083a2190" => :catalina
    sha256 "c5d220d0b53d59039301935657c6bbccb0602fbc02dbc52ef9c94c5db3cc4ecc" => :mojave
    sha256 "a3a05e00dd86b9910ea3077cefc95dbd1ee4a785d5b2c337c2ba1f9341ae0ecf" => :high_sierra
  end

  depends_on "go@1.12" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "vault server -dev"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/vault</string>
          <string>server</string>
          <string>-dev</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/vault.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/vault.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
