class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.3.6.tar.gz"
  sha256 "2d2f715fbe3aad679077d45e93a05a4b951811964e1e47ad7eba6e17d1d613a8"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a60504658e4f8fc9db1c4e43fb1888c4112e3e09594bcfeb72c7e69510e400b7" => :el_capitan
    sha256 "2a64cd0126e231534e49e49f6b120b22a572a72a421a0e89ce7ae61525d3c536" => :yosemite
    sha256 "1076c76cc675c0d385e5e34024ae01f8566d6b241d9507d8b803707330cf6523" => :mavericks
  end

  devel do
    url "https://github.com/coreos/etcd/archive/v3.0.0-beta.0.tar.gz"
    version "3.0.0-beta.0"
    sha256 "613c958a7ed9bb92069a46d5fc972a3c2b38b571ede475f88a5803f1f7bff1b3"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcd"
    bin.install "bin/etcdctl"
  end

  def plist; <<-EOS.undent
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
          <string>#{opt_bin}/etcd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      require "utils/json"
      test_string = "Hello from brew test!"
      etcd_pid = fork do
        exec "etcd", "--force-new-cluster", "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10
      etcd_uri = "http://127.0.0.1:4001/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output "curl --silent -L #{etcd_uri}"
      response_hash = Utils::JSON.load(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
