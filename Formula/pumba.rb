class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  url "https://github.com/gaia-adm/pumba/archive/0.4.4.tar.gz"
  sha256 "fdf11426752c69e79c2db10e2f57ef41c8b5d3d6815602ed11a95402b5db2d35"
  head "https://github.com/gaia-adm/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80995e4dc7ba0553b8a6ad611c45b26bf094c7b24f12af777866c5e7b20625c3" => :sierra
    sha256 "1374f57ce94bdce9a0512b9dbea753bf81d5ca4ceb5eddac3b6d06cc1c21470a" => :el_capitan
    sha256 "e74021e46d70d4d00f6c9358d1f827c90222833faa0e76e8626a14cae36be8c5" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/gaia-adm/pumba").install buildpath.children

    cd "src/github.com/gaia-adm/pumba" do
      system "glide", "install", "--strip-vendor"
      system "go", "build", "-o", bin/"pumba", "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/pumba --version")
    assert_match "Pumba version #{version}", output
  end
end
