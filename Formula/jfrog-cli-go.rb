class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.29.0.tar.gz"
  sha256 "00a8849c63a6e4387f24864c43b4af2e745d5ce4567cd2a2d74dc1be9891308a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e26a83a08f032240beb492a73a693a2bca99b66b5fc8221fc5ac3f497dc4487" => :mojave
    sha256 "eb90b59b3e5babb20ebd83f81aa43cf028545618b88f0d29dde1d9043bf55693" => :high_sierra
    sha256 "6aa816ef9817b96ed617c08b43d011e55ccf402f0e072ef240cbfad466bf4a22" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli-go"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
