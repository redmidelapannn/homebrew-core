class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.3.1",
      :revision => "fd8f4a7177e9ea509f27105ae4e55e6c68ece6f7"

  bottle do
    rebuild 1
    sha256 "34521e74f0956b6b604e4818f35e625ca20abcfa8d9e7deb52ce60474a1cfe15" => :catalina
    sha256 "76be09e359c9dfd5f3d53fc17af233ff40327f55ac7e411fa8a1373545a0ccb7" => :mojave
    sha256 "75d6f5707322eda4cee83e819c80b168890c7257969a9c4262438ab654f28ce3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/fortio.org/fortio").install buildpath.children
    cd "src/fortio.org/fortio" do
      system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio",
             "LIB_DIR=#{lib}"
      lib.install "ui/static", "ui/templates"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
