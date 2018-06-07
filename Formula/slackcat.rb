class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.4.tar.gz"
  sha256 "43c80b7d546bca51af47b3df8b79a2e5ce021042ea91d877e2feb33a7ca81305"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "1abf10e3e0bdb223ce2211c8953476d1bc3371ee931abcfd5cbe99c19eb20548" => :high_sierra
    sha256 "93a717219423b2d8446cfd3b49fdc068ebc1e0e781fd45d23f4c187e24f9515b" => :sierra
    sha256 "626d4656d8b26728f3e6f1582787bd1a0e991c83e58bce083957a103316899b8" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/vektorlab/slackcat").install buildpath.children
    cd "src/github.com/vektorlab/slackcat" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"slackcat",
           "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
