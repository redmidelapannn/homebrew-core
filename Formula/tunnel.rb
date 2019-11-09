class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.3.tar.gz"
  sha256 "463f117882605c358c42dde14a7f218d01eb1ab45755d4f86693be2ad18ee7c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e94b6f081c75af98a3935aa4093a299248873fe6c1a0aba02753aab74095fb9" => :catalina
    sha256 "957c9d5b6b204a5b7973095535b7f540fd7ff87166f71fc6e356a159a60f7cbc" => :mojave
    sha256 "b5b3cb34878f4ff78ab6b432a5c82942c7d1f8fa7079e75219c85911aaf1e83c" => :high_sierra
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
