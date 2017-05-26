class Stathat < Formula
  desc "Command-line interface to stathat.com"
  homepage "https://stathat.com"
  url "https://github.com/stathat/cmd/archive/v0.2.1.tar.gz"
  sha256 "9a63a8104da468e92fd2c50dba577f599cd0f23f93a67ac0babd36b8dfc843a0"

  head "https://github.com/stathat/cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c77163df225ff28bf3903def94d11875d1e3589af1982e961e4211baf304679" => :sierra
    sha256 "c39bce44d27c49f1b4d3c4fbf8e36dbb92ada13767dba8b79466bb99fd1b2425" => :el_capitan
    sha256 "17b16ecc57102b6cbfc8c4f97622370398a0a8768d44422369b51aaa781f950a" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/stathat/cmd/").install "stathat"

    system "go", "build", "-o", bin/"stathat", "-a", "github.com/stathat/cmd/stathat"
  end

  test do
    system "#{bin}/stathat", "version"
    system "#{bin}/stathat", "ping"
  end
end
