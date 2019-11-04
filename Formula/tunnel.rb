class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.0.tar.gz"
  sha256 "16e3ca86acc6cc3232f3ff6ef3480160773a6a6e23bbe85344ac9d6c9128420e"

  bottle do
    cellar :any_skip_relocation
    sha256 "224be39e364de76eb15e50e6d8042635650e603712b1f8c049747593e50d6e0b" => :catalina
    sha256 "549b80f60a4e45948f45f2f0ce2d5ebcb348b5271b900cc427dd41a155e4c3c4" => :mojave
    sha256 "61184b1aac75664fd73cabedd9502e88c99d96db9f04241cc61906381a63132a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
