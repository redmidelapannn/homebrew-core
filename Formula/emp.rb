class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.10.1.tar.gz"
  sha256 "b1cd7ee7cb3608075071c56e83d0e3ee9faea2a98b0d406f26be9e245d8f8b2d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "084ccde881677de3a45f91bfc8cc7d3d85ccb43a88413cbca248b3726605478d" => :el_capitan
    sha256 "19de11d533c1590afd6f70e237ba81d261447cd19174fd95a0c1973c0dc15e48" => :yosemite
    sha256 "3e6ce3757d21fd173484a106d7b13402a785a0109fe7124250010b57124de848" => :mavericks
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
    require "utils/json"

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
      res.body = Utils::JSON.dump([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match /v1  zab  Oct 1(1|2|3) \d\d:00  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip
    ensure
      server.shutdown
    end
  end
end
