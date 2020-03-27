class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.14.tar.gz"
  sha256 "83f7d63520171f052ff50d2e3f56675545350b0aa812b3634397c8d6916292fb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2fb9aadc487ff56d491091a506cfa64f307fc89e7633fe008d3049682957e239" => :catalina
    sha256 "6986c9cc8b43c67087adae3c2e3019cc4f5ef38c1bbf4edb0a794ca0c3003917" => :mojave
    sha256 "a5b0467d207629c591dff35fdfe8bac843a2ec733be7f61d3ddf9537572332a5" => :high_sierra
  end

  depends_on "go@1.13" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
