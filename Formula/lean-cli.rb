class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.17.0.tar.gz"
  sha256 "e796684fc4bb3d0c318e64a1afc314913023cbe6ae92dfa1df1cd5875954b276"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ad0130decd491cb885ef883317f62f2bb4e624aa68b33b3e6e310b3cc9215ea" => :high_sierra
    sha256 "150921c182c2c4eb94b86afdf2e57ecfc7c40595c106b3cba345c7b4cb3bc564" => :sierra
    sha256 "4b06c4ba422a6007e8ae930e1f65cfad87847eb80c3ba7bdc0244c4a86a0c02e" => :el_capitan
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
