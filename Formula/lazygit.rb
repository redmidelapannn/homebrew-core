class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.12.2.tar.gz"
  sha256 "d97b6bd51973f76a765a67118bd0903266dbb9c4a6ac071fa0b19eb3c0c599c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd91f0f7560f52cbf6ff650f9e6e919f5b0edfe793700a5f84cee277ed102fea" => :catalina
    sha256 "46163676e537c3ede63b74e585d7369d5da8888898f52fd857185ba42466b8be" => :mojave
    sha256 "01bbc6cd95be9f618e6d9a52c8da550c1227c7cc2038688daf2e16c66d061136" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
