class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.12.tar.gz"
  sha256 "cdafd383d866dca4bc96be002d5d25eeea4801d003456a0215e28a2fba5a0820"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "81e00ff4e2a58a974969bc3f6cf7ae48ba7f05a3d019a4c74d8fb5ff0b502040" => :mojave
    sha256 "bfd11c49e85cf83aa25a6ec1b5aa639ee519d0f4ffdb68a22e224ee5d6cd820e" => :high_sierra
    sha256 "f76a53b92a5b4c05a369ddb76002dc50b952f1aed5bf06dcc9254cdc8127ecd3" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/exercism/cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
