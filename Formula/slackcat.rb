class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.6.tar.gz"
  sha256 "e5c8f98f3048cccc3f8e49c0449435a839a18c7f12426643ac80731b63b829a9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b492b90ed966782932f0c587793140f4f4742546f52cb37c9a4e56dc6b12b43" => :mojave
    sha256 "d871f34b03be935e4e648334a5d5370e1a601bfc6387a33d908334b738a499bd" => :high_sierra
    sha256 "3b3b03e6fb47128b562ecf95c97b10f7e27301452595f4df06362c0562bbc774" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/vektorlab/slackcat"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"slackcat", "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
