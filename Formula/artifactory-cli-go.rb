class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface for Artifactory"
  homepage "https://github.com/JFrogDev/artifactory-cli-go"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.3.0.tar.gz"
  sha256 "29ba6b4cc46456caad300500050548fc0ad157fde102059e0778f0d68a35f4ba"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef853d5ebaf8675edf574266d8967fe70f7c5d7000cedef29ad97262093490b9" => :high_sierra
    sha256 "e5c8bc2f7010dbdfa758a1ce925c36067dcd20f3d5b22d57226ce8114ed2e7be" => :sierra
    sha256 "438e2705bd15d1a4c64a89c58f0efc570c6c44cb3c8a658c7fc6788070c0b923" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/artifactory-cli-go/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/art", "-v", "github.com/JFrogDev/artifactory-cli-go/art/"
  end

  test do
    actual = pipe_output("#{bin}/art upload")
    expected = "The --url option is mandatory\n"
    assert_equal expected, actual
  end
end
