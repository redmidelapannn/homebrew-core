class Sshcode < Formula
  desc "Run VS Code on any server over SSH"
  homepage "https://github.com/cdr/sshcode"
  url "https://github.com/cdr/sshcode/archive/v0.8.0.tar.gz"
  sha256 "235dc537d8b2d1425a8c90fc9ccc1f404cd01a03c6c04f2e7f1a0b48521e59aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "f347f6fb016efc73f4bda2858e8101f1f42a745a429f61db633457434bb70422" => :mojave
    sha256 "065ef17fcbda0bfa4db1928fead7662d506e73eb40bf11a27a52a3f75037d323" => :high_sierra
    sha256 "74b6afa0b9d799ce4519ed762d7aad264080b82a218e25eb1e5df776dd3f1130" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "on"
    sshcodepath = buildpath/"src/github.com/cdr/sshcode"
    sshcodepath.install buildpath.children

    cd "src/github.com/cdr/sshcode" do
      system "go", "build", "-o", "build/sshcode", "."
      bin.install "build/sshcode"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/sshcode", "--version"
  end
end
