class JfrogCli < Formula
  desc "Command-line interface for JFrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli/archive/1.33.2.tar.gz"
  sha256 "b6682085d1ed19448e32bd208227229de43a85bb7e85653bc332c714ffaeb425"

  bottle do
    cellar :any_skip_relocation
    sha256 "e86435fc6efe72932addde3d2cff1776a497a2f0ffea44d63fdfc3a98b2396b9" => :catalina
    sha256 "e435f8081afe8aabd975ba0516a37b25e3a1d308793c3123ec13201433ef9820" => :mojave
    sha256 "6ccfb53532ae72e2c65c29744d3f37e38bfb56ea2038dcd2c47f2631e9fb1627" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
