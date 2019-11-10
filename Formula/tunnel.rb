class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.4.tar.gz"
  sha256 "fb084b9571d39a3ec68b91dbaeae49d4a6de7b007f04eb2c3b5daa106a4c77f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "36c9d6195ae1035eab027f1ff46cdba46c4f4a96f6b875ad588a4ae92e9c6337" => :catalina
    sha256 "ec0fe1f9b9d300bf811f88faa2eb63cfe6492dfbe4690faeae2dc097a7e92636" => :mojave
    sha256 "964a9401cd3090ad6fbde534e9a30e6fd55999d52b923fb581b8f9ac471a79dc" => :high_sierra
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
