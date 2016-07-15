class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.3.0.tar.gz"
  sha256 "d2903d3723c8349ec09bc8c7ada1fcb60d835f248d4df1faf5fe6fbadf484f16"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "618495ea6dd0035c32435499597efc7ea46160d8e8c212bf749d9cc3b2835904" => :el_capitan
    sha256 "105010082327405a3f255279afee312b03d4af22571b7e65e612d201b94ed4d5" => :yosemite
    sha256 "e7e46e1ab63c05d80abc725108bc64a08adb3c4605645a35be73d4e3f14e3750" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end
