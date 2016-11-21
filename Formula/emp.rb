class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.11.0.tar.gz"
  sha256 "b091b07a7f6ed15a432201fed379de4b7aec0d481b9f9323ac060683b7dacf21"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27fe1169843d72180b734701244b9cce74d7adcf99fccfd2377c97df1c724fa4" => :sierra
    sha256 "6b7fdcb751beb9681f2a452c9ea095520b264cbae7d0dd2667fd60ee7280ca37" => :el_capitan
    sha256 "c6b78b97cdd0f37488f9e2620a7b5b47ba825d74f104a3c84c9e36c12212aa87" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/remind101/").mkpath
    ln_s buildpath, buildpath/"src/github.com/remind101/empire"

    system "go", "build", "-o", bin/"emp", "./src/github.com/remind101/empire/cmd/emp"
  end

  test do
    require "webrick"

    server = WEBrick::HTTPServer.new :Port => 8035
    server.mount_proc "/apps/foo/releases" do |_req, res|
      resp = {
        "created_at" => "2015-10-12T0:00:00.00000000-00:00",
        "description" => "my awesome release",
        "id" => "v1",
        "user" => {
          "id" => "zab",
          "email" => "zab@waba.com",
        },
        "version" => 1,
      }
      res.body = JSON.generate([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match /v1  zab  Oct 1(1|2|3)  2015  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip
    ensure
      server.shutdown
    end
  end
end
