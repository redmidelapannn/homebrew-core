class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.1",
     :revision => "b914b8a6bd707f220a83656e8c8e4c3995300417"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "977bf034c6f866e7e615de35492825c10cb30a730539767c4fd99f6758f4e4dd" => :mojave
    sha256 "77a23ec590933b1740b66d430fd1c98e57eaa28a98d4910c877ed3f3df5430c4" => :high_sierra
    sha256 "d0ada9bd85633979cc800a2005b6850f120936de8bff9d276044f8e87f8b0e21" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/VirgilSecurity/virgil-cli"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "virgil"
      bin.install "virgil"
    end
  end

  test do
    result = shell_output "#{bin}/virgil pure keygen"
    assert_match /SK.1./, result
  end
end
