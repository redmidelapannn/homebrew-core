class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.23.1.tar.gz"
  sha256 "a5200552acdf55592a6972900f2f658cb25dd6508793bc52fb3386a310a75414"

  bottle do
    cellar :any_skip_relocation
    sha256 "b02e93c6f0ea11aaab0557ee83e39d145a32a35cfeffca88aa77e51acbcbd552" => :mojave
    sha256 "2060379e9fd6a242e56ae4a3fe851a25e7a8f4268cb08322981e6a4bc07fdd29" => :high_sierra
    sha256 "96b67b36c12edf7270faf695dd859f2b01fe1f22da0136797da0890aaf48e302" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
