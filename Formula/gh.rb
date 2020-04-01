class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.6.3.tar.gz"
  sha256 "22d990ff795ff271bc626dcec424551853b095e5810e700531cda337daaa8b1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "269d98911d4f0d98a35cefb4a2f803b136bee483bbbc9f60f2dfdbb88f0e885f" => :catalina
    sha256 "1d0de8488c625f060a05843a89c44732a3c08c576a38ca4fb27e6dd0f92ee75c" => :mojave
    sha256 "9c81c59eaf0b4a3f9fb0a897e4f730d02cc5a544b5684964599e6ae956831881" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/name, "./cmd/gh"

    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1", 1)
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1", 1)
  end
end
