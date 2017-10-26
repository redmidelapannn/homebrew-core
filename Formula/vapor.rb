class Vapor < Formula
  desc "Simplifies common command-line tasks when using Vapor."
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/releases/download/3.0.3/macOS-sierra.tar.gz"
  version "3.0.3"
  sha256 "0461af9672896918e66bf3f698f0e78df0b8eb51c2a4a115919a0a30e055452c"

  bottle do
    cellar :any
    sha256 "905718809257c7cf80c3df39c12968b7f248cb76a85bca44d656a53e1d95d84e" => :high_sierra
    sha256 "905718809257c7cf80c3df39c12968b7f248cb76a85bca44d656a53e1d95d84e" => :sierra
    sha256 "905718809257c7cf80c3df39c12968b7f248cb76a85bca44d656a53e1d95d84e" => :el_capitan
  end

  depends_on "vapor/tap/ctls" => :run

  def install
    bin.install "vapor"
  end

  test do
    system "#{bin}/vapor", "--help"
  end
end
