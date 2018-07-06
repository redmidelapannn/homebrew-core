class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.17.0.tar.gz"
  sha256 "da21779ddeea24b9760e2d175e8516ea845a143e23cdb8f9790f6909b1eff7e7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7de8d2e4f0656fe1b674e735d1e2706e0d93de763356c653f8cdcab188a29b08" => :high_sierra
    sha256 "08e9e92e65b4606a4f95d047ba9064036e31fb562d5f3e3a9906653739d96382" => :sierra
    sha256 "ba53fc7b63c08fbff0eced2677fc9fed39f034ba7477734f9858b442544f40e2" => :el_capitan
  end

  depends_on "go" => :build

  def install
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
