class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.6.0.tar.gz"
  sha256 "5da5e904ee1a46c367652a9df4f4787a63fa9ec5934f44698f3aae7e8bc25680"

  bottle do
    cellar :any_skip_relocation
    sha256 "623d6192f2a54e3e0ebb71f8fb56e54a873b3de0bd999c4fd75112884e099eaf" => :sierra
    sha256 "6febd1355d658f72a87438b005f0699ba5ac30db089dd596d1700cf2ec502676" => :el_capitan
    sha256 "d5262211a5243ba4c415a152b7318654effb71150543704ca2592ff08c97cfa0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
