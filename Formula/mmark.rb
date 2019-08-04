class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.46.tar.gz"
  sha256 "fa64a7321ff8cc531a0caa36af2a72057c5bebd634b623407b9d6415e7184003"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c94312746830facfb71fef3309067307ae12837a86eddc6e5ecbe063610bc49a" => :mojave
    sha256 "85eb187af4f85cd96e81ba44864c085ea934bd316af82cff5e18ead43e64ee66" => :high_sierra
    sha256 "ab3d8f5d0a0d0afb9765952198cd76fc068d8b3fa81ce668ce82698d9dce55a8" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
