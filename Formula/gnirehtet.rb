class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  url "https://github.com/Genymobile/gnirehtet/archive/v2.4.tar.gz"
  sha256 "5ff179fca58e85473e737680a72aeb84c710082283bfe9cce4b044b3c2436c4d"
  head "https://github.com/Genymobile/gnirehtet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ddbfef75e3e46e55c36dfd8cc7f636d8f80008db2b06e8d682948ce0f39bea28" => :catalina
    sha256 "b9cd55d00215849419542b3cc3461a8a2b470e3229195663c7cf8ee89f82bf8a" => :mojave
    sha256 "867a431b42cedfc61c2ace06da151ccf0c7d1952cb85f2864807a93b2aa9ddf0" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.4/gnirehtet-java-v2.4.zip"
    sha256 "10b6cca49a76231fbf8ac3428cf95e9f1c193c4f47abe2b8e2aa16746eb8cc21"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", "--locked", "--root", libexec, "--path", "relay-rust"
    mv "#{libexec}/bin/gnirehtet", "#{libexec}/gnirehtet"

    (bin/"gnirehtet").write <<~EOS
      #!/bin/bash
      if [[ "$1" == "install" ]]; then
        shift
        echo "Installing #{libexec}/gnirehtet.apk"
        adb install -r #{libexec}/gnirehtet.apk
      else
        #{libexec}/gnirehtet $*
      fi
    EOS
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew cask install android-platform-tools
    EOS
  end

  test do
    gnirehtet_err = "#{testpath}/gnirehtet.err"
    gnirehtet_out = "#{testpath}/gnirehtet.out"

    port = free_port
    begin
      child_pid = fork do
        Process.setsid
        $stdout.reopen(gnirehtet_out, "w")
        $stderr.reopen(gnirehtet_err, "w")
        exec bin/"gnirehtet", "relay", "-p", port.to_s
      end
      sleep 3
      system "socat", "-T", "1", "-", "TCP4:127.0.0.1:#{port}"
    ensure
      pgid = Process.getpgid(child_pid)
      Process.kill("HUP", -pgid)
      Process.detach(pgid)
    end

    assert_empty File.readlines(gnirehtet_err)

    output = File.readlines(gnirehtet_out)
    assert output.any? { |l| l["TunnelServer: Client #0 connected"] }
    assert output.any? { |l| l["TunnelServer: Client #0 disconnected"] }
  end
end
