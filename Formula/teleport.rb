class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.4.0.tar.gz"
  sha256 "2d972587f14e3d35ecf3a2c45a9a0b5719565d5956e2b9ded02a0e5ab7c90c07"

  bottle do
    rebuild 1
    sha256 "5a04bc22f51c57e65e3ede6a2c626b6ec5d9794bcb06eb55a69e4fd54cb84e1f" => :high_sierra
    sha256 "8da5f439dc3a90ca8b55fd52e73a1394a8def4917cb85f6865526a55185c11f4" => :sierra
    sha256 "ee8093679a55567b0c3849da9d3929e1c6a3383bd7ef094fdbbb1239d8f66648" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
