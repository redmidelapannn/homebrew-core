require "language/go"

class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.4.0.tar.gz"
  sha256 "ec615c5d2584e5761ac20c6a6df6139f7018de65934f4c2d05e69cfd35d1d89e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4ba7e38a7f606d7a64beb194e3449b43d999e971d56355d6c8a7d0955bcbe6c5" => :sierra
    sha256 "d178cb55b977d3743e533453a907ec8529a0bd7e6882bcff98e3f28d70df3970" => :el_capitan
    sha256 "04fba06172eae6863dfb05653bdbc84fe5fbdc4cbd4cede0a97458084907a539" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "89fe3459b5c829c32e89bdff9c43f18aad728f2f"
  end

  def install
    require "time"
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/pilosa/"
    ln_s buildpath, buildpath/"src/github.com/pilosa/pilosa"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/rakyll/statik" do
      system "go", "install"
    end
    system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=#{version}"
  end

  plist_options :manual => "pilosa server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/pilosa</string>
            <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa", "server"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
      assert_match("<!DOCTYPE html>", shell_output("curl --user-agent NotCurl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
