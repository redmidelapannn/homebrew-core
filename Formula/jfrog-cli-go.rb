class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.26.3.tar.gz"
  sha256 "3248e06e079b27cb40a71320be0977d47e3fe94090175b91662bb1fc7e7ebb06"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "20503da1b8d627fa30df1719889a10b881dd3d51f9afe00f31fcd55239864b5b" => :mojave
    sha256 "8a66374ada9f62edc57919c044858ee9c80898c223d41261851eed8dfb7657e5" => :high_sierra
    sha256 "c76d238374a8ee7d27603e866fa8e9a1d46d7604271fc6629e985c47fb2448ba" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]

    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
