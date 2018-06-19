class PilosaConsole < Formula
  desc "Web-based user interface for Pilosa"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/console/archive/v0.1.tar.gz"
  sha256 "cb79a282c5050ae0ed195597b0c5ee4467515d04061e3c9dd7086527ddbaee78"

  bottle do
    cellar :any_skip_relocation
    sha256 "c241220c7cf77acbe67ba810b2cb2caca0aabac320e533e567718092fe1d691e" => :high_sierra
    sha256 "4cf5fa968e39958624516023d597ee0f363295ecb43d9b523118083d4cc49571" => :sierra
    sha256 "55e23aa89ce4fa2589f6b6fe14fc0a43a581327e409d9e92b1dd61826daa559b" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "go-statik" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pilosa/console").install buildpath.children

    cd "src/github.com/pilosa/console" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa-console", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa-console"
      end
      sleep 0.5
      assert_match("<!DOCTYPE html>", shell_output("curl localhost:8000"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
