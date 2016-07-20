class Vaulted < Formula
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "22d05131f6d6cf2e66b65e7c0ba9862142312723e854063e3f3b8414cdedafbb"

  head "https://github.com/miquella/vaulted"

  bottle do
    cellar :any_skip_relocation
    sha256 "35bd5cd56104062aec1fbeaa07b6177674763bf061ed54e92a65ccb980f6b2bd" => :el_capitan
    sha256 "0ccb7e421d6e1443e658511ad49cad57546a84ceab3fe8871a5069b5a8492e66" => :yosemite
    sha256 "845716dfca47c3e3d765b015351e54c3fa2ea530887e6723e794e6118dd1bd39" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "github.com/bgentry/speakeasy"
    system "go", "get", "github.com/miquella/vaulted/vault"

    #Build and install Vaulted
    system "go", "build", "-o", "vaulted"
    bin.install "vaulted"
  end
end
