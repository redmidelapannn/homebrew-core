class Eris < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/eris-ltd/eris-cli/archive/v0.11.4.tar.gz"
  sha256 "e2eb02d01b76e8be9f28aac31b2e56ebadc4d0decb21fcfefb2f219cb03d1238"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "27c951edf6383463376462acf8befeba14f84213b7fab36bd4f5ccead4d49444" => :el_capitan
    sha256 "0867ffcade9f901c0b489e3a9339f2202ee90bd0299d53a9118369c25f952039" => :yosemite
    sha256 "5ec1b655c7e21b647f265ceac532341514b91172f4afed7d3133fe60482431e4" => :mavericks
  end

  devel do
    url "https://github.com/eris-ltd/eris-cli/archive/v0.12.0-rc1.tar.gz"
    sha256 "1924f18a721c0533570191a857fad03e1c4a395b2d1a0f34826499ac41ccf144"
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/eris-ltd").mkpath
    ln_sf buildpath, buildpath/"src/github.com/eris-ltd/eris-cli"
    system "go", "build", "-o", "#{bin}/eris", "github.com/eris-ltd/eris-cli/cmd/eris"
  end

  test do
    system "#{bin}/eris", "--version"
  end
end
