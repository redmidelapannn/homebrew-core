class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.13.tar.gz"
  sha256 "7b70b4728f90811c9bee7523af52458015bac65e22c6cee5be66122711bd1451"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ae56d3d34c43a7132132d0f74665eab3402e420452420296a54b1da5aca35c9" => :catalina
    sha256 "b44930302149261a0ebc9d58c24959294a5305b3707b00db1d4a823e92faa2ce" => :mojave
    sha256 "a4b32204e22df2d7f1965252e32d22bc6ffc0618a4b48e5415d0ff89a94f8547" => :high_sierra
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
