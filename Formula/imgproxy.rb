class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.12.0.tar.gz"
  sha256 "79a5e191bdda16a27d37e9d3b5e534a76df26bb5e3c5ff60525651a695d88067"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ac7e34b1e2de8803b5e907227792732d11b2d93cd94ebd5d0be630d6843f5a40" => :catalina
    sha256 "4a428a9067412cf238dfbc851cef79457aab5a50d613b06ec4015f509cdd0480" => :mojave
    sha256 "9c448c78d4f41f32d0c9110c84ed6c1a643c3587f523f1a307fbf8a3ef256e1a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 3

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png"
    assert_equal 0, $CHILD_STATUS
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "1 x 1", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
