class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.6.tar.gz"
  sha256 "8d692a1220a85884f231c3480e0da305678d86660e795a5eb510d076945adf65"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ec9396441ce69ed89bb0a2e584a9b3c4ed371e8104580ce70b733d892fd94968" => :catalina
    sha256 "e6985f533499b61a40f812b855e5ac715b3b0751495db4d7ca57d8a5bf676339" => :mojave
    sha256 "b74cca098a4b44080fbe52e741a79f543fd4828aaca65a6cdf280a974fa49b54" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sosedoff/pgweb").install buildpath.children

    cd "src/github.com/sosedoff/pgweb" do
      # Avoid running `go get`
      inreplace "Makefile", "go get", ""

      system "make", "build"
      bin.install "pgweb"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
