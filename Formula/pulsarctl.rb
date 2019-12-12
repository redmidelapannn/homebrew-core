class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in golang"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl.git",
      :tag      => "v0.2.0",
      :revision => "2faa2b8033f51ad8ea3d246fd5effa47263262e2"
  sha256 "d0d6b55017cf349dd893248b0541c8026db9be5d5a7c5523d7bb91426c279fe3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f710c405c496103e1d91756825ff1b6bd46b3adafe64dc8b8c14532047079a9c" => :catalina
    sha256 "6fbce1297d326f7a2733bdb966465f2678296c5e3a281c5e1114eaf65e3eac12" => :mojave
    sha256 "14c6927aafe048c1d6f17ac3b4d468b13363c98858bf0a9fcd7ff4c69df2bfeb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin / "pulsarctl"
  end

  test do
    out = shell_output("#{bin}/pulsarctl 2>&1")
    assert_match "a CLI for Apache Pulsar", out
  end
end
