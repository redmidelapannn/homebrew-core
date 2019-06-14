class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "v0.7.0",
      :revision => "07d1041389d1cb0b8a9e69cda40e3afa762bbc72"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bb7efb05664c08799df4930eee3e231f6098303eac7913aee7730fd2ff73bdf" => :mojave
    sha256 "47ec845022e0de9cb9a4b9c6ca56c451e117352d8c3d1042c96287d5eb81595a" => :high_sierra
    sha256 "811edc94dd7816c495e33b1611210ab9cbbc738f62d747ccf5ea06b35880d0d7" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/kyma-project/cli/"
    bin_path.install Dir["*"]

    cd bin_path do
      system "make", "resolve"
      system "make", "build"
      bin.install "bin/kyma-darwin"
      mv bin/"kyma-darwin", bin/"kyma"
    end
  end

  test do
    output = shell_output("#{bin}/kyma --help")
    assert_match "controls a Kyma cluster.", output

    output = shell_output("#{bin}/kyma version --client")
    assert_match "Kyma CLI version", output
  end
end
