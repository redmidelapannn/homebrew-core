class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.17.tar.gz"
  sha256 "8e9bdd72cbc5a9e6f89e61017c8f6f8b070b5dab23d926d9234ef5cd9e014eda"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f1d7f1a0c48b4d508abdca253d6ed326126e40b2bcb5780e7a20a660a8ce9e0b" => :mojave
    sha256 "d065afe3d29d64a6ddadd0a2a91b006e0d3208adab298f583f3ca5eba0d60d0e" => :high_sierra
    sha256 "587d6d206987078360dd1fbedeb3d165d83dbf2a5041498d7ded2a4c9a3865f5" => :sierra
    sha256 "f87c8ba8c23b241889062603794003963d4e9ea9df9d906078399562d7476715" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags",
           "-X github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew",
           "github.com/scaleway/scaleway-cli/cmd/scw/"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw.bash"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
